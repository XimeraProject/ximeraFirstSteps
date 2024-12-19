-- post-process HTML files created by TeX4ht to a form suitable for Ximera
local M = {}
local log = logging.new("html")
local domobject = require "luaxml-domobject"
local pl = require "penlight"
local path = require "pl.path"

local url = require("socket.url")
-- local url = require "lualibs-url"


-- Function to create a backup copy of a file
local function backup_file(original_filename, extension)
  -- Determine the backup filename (e.g., "file.txt" -> "file.txt.bak")
  local backup_filename = original_filename .. "." .. (extension or "ORG")

  -- Open the original file for reading in binary mode
  local original_file = io.open(original_filename, "rb")
  if not original_file then
      log:error("backup_file: Could not open the original file "..original_filename.." for reading.")
      return false
  end

  -- Read the entire contents of the original file
  local content = original_file:read("*all")
  original_file:close()

  -- Open the backup file for writing in binary mode
  local backup_file = io.open(backup_filename, "wb")
  if not backup_file then
      log:error("backup_file: Could not open the backup file"..backup_filename.." for writing.")
      return false
  end

  -- Write the content to the backup file
  backup_file:write(content)
  backup_file:close()

  log:debug("Backup created: " .. backup_filename)
  return true
end


--- find metadata for the HTML file
---@param file metadata
---@return metadata|nil html file
---@return string? error
local function find_html_file(file)
  -- file metadata passed to the process function are for the TeX file 
  -- we need to find metadata for the output HTML file
  log:trace("find_html_file for "..file.filename)
  for _, output in ipairs(file.output_files) do
    -- log:debug("Checking for 'html': "..(output.metadata.filename or "") )
    if output.extension == "html" then
      log:trace("Returning: "..(output.filename or ""))
      -- require 'pl.pretty'.dump(output)
      return output
    end
  end
  return nil, "Cannot find output HTML file for "..file.filename
end


local html_cache = {}

--- load DOM from a HTML file
---@param filename string
---@return DOM_Object|nil dom
---@return string? error_message
local function load_html(filename)
  -- cache DOM objects
  if html_cache[filename] then 
    log:trace("returning cached dom ")
    -- require 'pl.pretty'.dump(domobject.html_parse(content))
    return html_cache[filename]
  else
    log:debug("Loading and parsing html for "..filename)
    local f = io.open(filename, "r")
    if not f then return nil, "Cannot open HTML file: " .. (filename or "") end
    -- log:debug("Opened html for "..filename)
    local content = f:read("*a")
    f:close()
    -- log:debug("Dumping html for "..filename..": "..content)
    html_cache[filename] = domobject.html_parse(content)
    log:trace("returning non-cached dom ")
    return domobject.html_parse(content)
  end
end

--- detect if the HTML file is xourse
---@param dom DOM_Object
---@return boolean
local function is_xourse(dom, html_file)
  local metas = dom:query_selector("meta[name='description']")
  if #metas == 0 then
    -- log:warning("Cannot find any meta[description] tags in " .. html_file.absolute_path)
    log:debug("No meta[description] tags in " .. html_file.absolute_path .. " (and thus not a xourse)")
  end
  for _, meta in ipairs(metas) do
    if meta:get_attribute("content") == "xourse" then
      log:debug("File "..html_file.relative_path.." is a xourse")
      return true
    else
      log:debug("File "..html_file.relative_path.." has not-a-xourse description tag  "..(meta.get_attribute("content") or ""))
    end
  end
  -- log:debug("File "..html_file.relative_path.." is not a xourse ")
  return false
end

local function is_element_empty(element)
  -- detect if element is empty or contains only blank spaces
  local children = element:get_children()
  if #children > 1 then return false 
  elseif #children == 1 then
    if children[1]:is_text() then
      if children[1]._text:match("^%s*$") then
        return true
      end
      return false
    end
    return false
  end
  return true
  
end

--- Remove empty paragraphs
---@param dom DOM_Object
local function remove_empty_paragraphs(dom)
  for _, par in ipairs(dom:query_selector("p")) do
    if is_element_empty(par) then
      log:trace("Removing empty par")
      par:remove_node()
    end
  end
end

local function read_title_and_abstract(activity_dom)
  local title, abstract
  local title_el = activity_dom:query_selector("title")[1]
  if title_el then title = title_el:get_text() end
  log:debug("Read title ", title)
  local abstract_el = activity_dom:query_selector("div.abstract")[1]
  if abstract_el then
    return title, abstract_el:get_text()
  end
  return title, nil
end

local function get_labels(activity_dom)
  local labels = {}
  for i, anchor in ipairs(activity_dom:query_selector("a.ximera-label")) do
    -- require 'pl.pretty'.dump(anchor)
    local label = anchor:get_attribute("id")
    labels[label] = (labels[label] or 0) + 1
    log:tracef("Found label %s", label )
    if labels[label] > 1 then
      log:warning("Duplicate label ",label)
    end 
  end
  return labels
end

--- Transform Xourse files
---@param dom DOM_Object
---@param file metadata
---@return DOM_Object
local function transform_xourse(dom, file)
  for _, activity in ipairs(dom:query_selector("a.activity")) do
    local href = activity:get_attribute("href")
    log:trace("activity", href)
    if href then
        -- some activity links don't have links to HTML files
        -- remove the optional '.tex'
      local newhref = href
      if path.extension(href) == ".tex" then newhref, _ = path.splitext(href) end
      -- add .html if no extension (anymore)
      if path.extension(newhref) == "" then newhref = newhref .. ".html" end
      
      if newhref ~= href then 
        -- TODO: href has now added .html suffix. but maybe it was without suffix for some specific reason in the first place
        log:debug("Resetting href to "..newhref .. "( from "..href..")") 
        activity:set_attribute("href",newhref)
      end
      
      local htmlpath = file.absolute_dir .. "/" .. newhref
      
      if not path.exists(htmlpath) then 
        log:error("HTML file "..htmlpath.." for activity in "..file.filename.." not (yet?) found; SKIPPING add/update title and abstract")
      else
        -- add the title and abstract of the activity to the xourse file ...
        log:debug("Updating title/abstract for activity ", htmlpath)

        local activity_dom, msg = load_html(htmlpath)
        if not activity_dom then
          log:error(msg)
        else

          local title, abstract = read_title_and_abstract(activity_dom)
          -- add titles and abstracts from linked activity HTML
          -- local parent = activity:get_parent()
          local parent = activity
          -- local pos = activity:find_element_pos()
          if title and title ~= "" then
            local h2 = parent:create_element("h2")
            local h2_text = h2:create_text_node(title )
            log:debug("Adding h2 for "..href..": "..title) 
            h2:add_child_node(h2_text)
            parent:add_child_node(h2,1)
          end
          -- the problem with abstract is that Ximera redefines \maketitle in TeX4ht to produce nothing, 
          -- abstract in Ximera is part of \maketitle, so abstracts are missing in the generated HTML
          if abstract then
            --require 'pl.pretty'.dump(abstract)
            local h3 = parent:create_element("h3")
            local h3_text = h3:create_text_node(abstract)
            log:debug("Adding abstract (h3) for "..href..": "..abstract) 
            h3:add_child_node(h3_text)
            parent:add_child_node(h3,1)
          end
        end
      end
    end
  end

  return dom
end

--- return sha256 digest of a file
---@param filename string
---@return string|nil hash
---@return unknown? error
local function hash_file(filename)
  -- Xake used sha1, but we don't have it in Texlua. On the other hand, sha256 is built-in
  local f = io.open(filename, "r")
  if not f then return nil, "Cannot open TeX dependency for hashing: " .. (filename or "") end
  local content = f:read("*a")
  f:close()
  -- the digest return binary code, we need to convert it to hexa code
  local bincode = sha2.digest256(content)
  local hexs = {}
  for char in bincode:gmatch(".") do
    hexs[#hexs+1] = string.format("%X", string.byte(char))
  end
  return table.concat(hexs)
end



--- Add metadata with TeX file dependencies to the HTML DOM
---@param dom DOM_Object
---@param file metadata
---@return DOM_Object
local function add_dependencies(dom, file)
  -- we will add also TeX file of the current HTML file
  local t = {file}
  -- copy dependencies, as we have an extra entry of the current file
  for _, x in ipairs(file.dependecies) do t[#t+1] = x end
  local head = dom:query_selector("head")[1]
  if not head then log:error("Cannot find head element " .. file.absolute_path:gsub("tex$", "html")) end
  for _, dependency in ipairs(file.dependecies) do
    log:debug("dependency", dependency.relative_path, dependency.filename, dependency.basename)
    local hash, msg = hash_file(dependency.absolute_path)
    if not hash then
      log:warning(msg)
    else
      local content = hash .. " " .. dependency.filename
      local meta = head:create_element("meta", {name = "dependency", content = content})
      local newline = head:create_text_node("\n")
      head:add_child_node(meta)
      head:add_child_node(newline)
    end

  end
  return dom
end



--- get file extension 
--- @param relative_path string file path
--- @return string extension
local function get_extension(relative_path)
  return relative_path:match("%.([^%.]+)$")
end


--- Get all files 'associated' with a given file (i.e. images)
---@param dom DOM_Object
---@param file metadata
---@return table
local function get_associated_files(dom, file)
  log:debug("get_associated_files for "..file.filename)
  -- pl.pretty.dump(file)
  local ass_files = {}
  local isXimeraFile = dom:query_selector("meta[name='ximera']")[1]
  if not isXimeraFile then 
      log:warning(file.filename.." is not a ximera file (no meta[name='ximera' tag])")
  end

  local title, abstract = read_title_and_abstract(dom)
  file.title = title or ""
  file.abstract = abstract or ""

  log:debug(string.format("Added title '%20.20s...' and abstract '%.10s...'", title, abstract))


  -- Add images 
  for _, img_el in ipairs(dom:query_selector("img") ) do
    local src = img_el:get_attribute("src")
    src = (file.dir or ".").."/"..src
    log:debug("Found img "..src)

    if not path.exists(src) then
      log:error("Image file "..src.." does not exist")
    end
    if path.getsize(src) == 0 then
      log:error("Image file "..src.." has size zero")
    end

    local u = url.parse(src)
    
    ass_files[#ass_files+1] = src
    
    if false and get_extension(u.path) == "svg"
    then
      local png  = u.path:gsub(".svg$", ".png")
      log:debug("also adding  "..png)
      ass_files[#ass_files+1] = png
    end
    -- sourceUrl, err := url.Parse(source)

    -- if err == nil {
    --   if sourceUrl.Host == "" {
    --     imgPath := filepath.Clean(filepath.Join(filepath.Dir(htmlFilename), sourceUrl.Path))
    --     results = append(results, imgPath)

    --     if filepath.Ext(imgPath) == ".svg" {
    --       pngFilename := strings.TrimSuffix(imgPath, filepath.Ext(imgPath)) + ".png"
    --       results = append(results, pngFilename)
    --     }
    --   }
    -- }
  
  end
  log:debug("get_associated_files done "..file.filename)

  return ass_files
end

--- Save DOM to file
---@param dom DOM_Object
---@param filename string
local function save_html(dom, filename)
  local f = io.open(filename, "w")
  if not f then
    return nil, "Cannot save updated HTML: " .. (filename or "")
  end
  f:write(dom:serialize())
  f:close()
  return true
end


-- local function osExecute(cmd)
--   log:info("Exec: "..cmd)
--   local fileHandle = assert(io.popen(cmd .. " 2>&1", 'r'))
--   local commandOutput = assert(fileHandle:read('*a'))
--   local returnCode = fileHandle:close() and 0 or 1
--   commandOutput = string.gsub(commandOutput, "\n$", "")
--   log:info("Gets: "..returnCode..": "..commandOutput)
--   return returnCode, commandOutput
-- end

--- Post-process HTML files
---@param file metadata 
---@return boolean status
---@return string? msg
local function process(file)
  log:debug("process "..file.absolute_path)
  
  -- we must find metadata for the HTML file, because `file` is metadata of the TeX file
  local html_file, msg = find_html_file(file)
  if not html_file then 
    log:error("No HTML file found for "..file.relative_path)
    return false, msg 
  end
  -- log:debug("Found html_file "..(html_file.filename or "").." for file "..file.filename)
 
  local html_name = html_file.absolute_path
  
  -- only for debugging
  -- local hash_orig = hash_file(html_name)
  -- backup_file(html_name, hash_orig..".bak" or "ORIG.bak")
  
  local dom, msg = load_html(html_name)
  if not dom then return false, msg end
  remove_empty_paragraphs(dom)
  add_dependencies(dom, file)


  log:debug("Check if .jax file is present") 
  local jax_file = html_name:gsub(".html$", ".xmjax")
  if not path.exists(jax_file) then
    log:warning("Strange: no JAX file with extra Latex commands for MathJAX")
    jax_file = nil
  end

  if jax_file then

  local preambles = dom:query_selector("div.preamble")

  if #preambles == 0 then
    log:error("No div.preamble in html : please add one") 
  end

  local preamble = preambles[1]
  local scrpt = preamble:create_element("script")
  scrpt:set_attribute("type", "math/tex")
  
  
  local f = io.open(jax_file, "r")
  local cmds = f:read("*a")
  f:close()
  local filtered_commands= cmds:gsub("[^\n]*[:*@].-\n", "")
  
  log:infof("Adding %d \newcommand (%d filtered)",#filtered_commands,#cmds) 
  local scrpt_text = scrpt:create_text_node(filtered_commands)
  scrpt:add_child_node(scrpt_text)
  preamble:add_child_node(scrpt)

  log:debug("No 'activity' card found ??? ") 

  end

  local title, abstract = read_title_and_abstract(dom)
  file.title = title or ""
  file.abstract = abstract or ""
  
  if is_xourse(dom, html_file) then
    transform_xourse(dom, file)

    
  log:debug("Checking if a 'part' is present") 
  local part = dom:query_selector(".card.part")

  if #part == 0 then
    log:debug("No parts: add one") 
    
    local body = dom:query_selector("body")[1]
    local first_activity = dom:query_selector(".card.activity")[1]
    if first_activity then
      log:info("Adding default card of type 'part' (HACK: needed by current preview server)") 
      local h1 = body:create_element("h1")
      local h1_text = h1:create_text_node("Main Part")
      h1:add_child_node(h1_text)
      h1:set_attribute("class", "card part")
      body:add_child_node(h1,6)    -- the 3 is a guess  
    else
      log:debug("No 'activity' card found ??? ") 
    end
  end

  --<h1 class='card part' id='part1'>The First Topic of This Course</h1>


  end

  -- Not needed here ...???
  -- local ass_files = get_associated_files(dom, html_file)
  if string.match(html_name,".make4ht.") then
    html_name = html_name:gsub(".make4ht","")
    -- file.absolute_path = file.absolute_path:gsub(".make4ht","")
    -- file.relative_path = file.relative_path:gsub(".make4ht","")
    -- file.extension="html"
  end 

  log:infof("Adapted html being saved as %s", html_name )
  return save_html(dom, html_name) 
end

M.process = process
M.load_html = load_html
M.get_labels = get_labels
M.get_associated_files = get_associated_files

return M
