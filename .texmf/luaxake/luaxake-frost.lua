local M = {}
local pl = require "penlight"
local path = require "pl.path"
local html = require "luaxake-transform-html"
local files = require "luaxake-files"
local log = logging.new("frost")

local json = require("dkjson")

--- save Ximera metadata.json file  (with labels/xourses/...)
--- @param xmmetadata table ximera metadata table
--- @return boolean success 
local function save_as_json(xmmetadata)
    local file = io.open("metadata.json", "w")
  
    if file then
        local contents = json.encode(xmmetadata)
        file:write( contents )
        io.close( file )
        return true
    else
        return false
    end
  end
  
  

local function osExecute(cmd)
    log:debug("Exec: "..cmd)
    local fileHandle = assert(io.popen(cmd .. " 2>&1", 'r'))
    local commandOutput = assert(fileHandle:read('*a'))
    local returnCode = fileHandle:close() and 0 or 1
    commandOutput = string.gsub(commandOutput, "\n$", "")
    if returnCode > 0 then
        log:warningf("Command %s returns %d: %s", cmd, returnCode, commandOutput)
    end
    log:trace("returns "..returnCode..": "..commandOutput..".")
    return returnCode, commandOutput
end

local function get_output_files(file, extension)
    local result = {}
    for _, entry in ipairs(file.output_files) do
        if entry.extension == extension then --and entry.info.type == targetType then
            if extension == "make4ht.html" then
                local file = files.get_metadata(entry.reldir, entry.basenameshort..".html")
                require 'pl.pretty'.dump(entry)
                require 'pl.pretty'.dump(file)
                table.insert(result, file)
                log:debug(string.format("Hacking %-4s outputfile: %s ", file.extension, file.absolute_path))
            else
                table.insert(result, entry)
                log:debug(string.format("Adding %-4s outputfile: %s ", entry.extension, entry.absolute_path))
            end
        else
            log:tracef("Skipping %-4s outputfile: %s ", entry.extension, entry.absolute_path)
        end
    end
    return result
end

local function get_git_uncommitted_files()
     local ret, out = osExecute("git ls-files --modified --other  --exclude-standard")
    if ret > 0 then
        osError("Could not get git info: %s",out)
        out = "GIT ERROR"
    end
    local utils = require "pl.utils"
    return utils.split(out,"\n")
end

-- -- Recursive function to list all files in a directory
-- function list_files(path, files)
--     files = files or {}
--     for file in lfs.dir(path) do
--         -- Skip "." and ".." (current and parent directory)
--         if file ~= "." and file ~= ".." then
--             local full_path = path .. "/" .. file
--             local attr = lfs.attributes(full_path)
            
--             -- If it's a directory, recurse into it
--             if attr.mode == "directory" then
--                 list_files(full_path,files)
--                 --table.move(nfiles,1,#nfiles,#files+1,files)
--             else
--                 -- If it's a file, print its path
--                 -- f:write(full_path.."\n")
--                 files[#files+1] = full_path
--              end
--         end
--     end
--     return files
-- end
    

-- -- Function to find the first table with a given key/value using Penlight
-- local function find_entry(array, key, value)
--     for _, entry in ipairs(array) do
--         if entry[key] == value then
--             return entry  -- Return the first matching entry
--         end
--     end
--     return nil  -- Return nil if no match is found
--   end


-- function move_to_downloads(file, cmd_meta, root_dir)
--     local folder = string.format("%s/%s/%s",root_dir, cmd_meta.download_folder, file.dir)
    
--     require 'pl.pretty'.dump(cmd_meta)
--     require 'pl.pretty'.dump(file)
--     local src = find_entry(file.output_files, "extensionlong", cmd_meta.extension)
--     -- local src = file.output_files[1].absolute_path    -- TODO: fix
    
--     local tgt = string.format("%s/%s.%s", folder, file.basename, src.extension)
--     -- require 'pl.pretty'.dump(src)
--     if src and path.exists(src.absolute_path) then
--       log:infof("Moving %s to %s", src.absolute_path, tgt)
--       pldir.makepath(folder)
--       plfile.copy(src.absolute_path, tgt)
--     else
--       log:warningf("No output file found for ",file.relative_path)
--     end
--     return 1, 'NOK'
--   end


--- Frosting: create a 'publications' commit-and-tag
---@param file metadata    -- presumably only root-folder really makes sense for 'frosting'
---@return boolean status
---@return string? msg
local function frost(tex_files, to_be_compiled_files, root)
    log:debug("frost")

    local uncommitted_files = get_git_uncommitted_files()

    if uncommitted_files then
        log:warningf("There are %d uncommitted files; serving only to localhost", #uncommitted_files)
    end
    
    if #to_be_compiled_files > 0 then
        log:warningf("There are %d file to be compiled; serving only to localhost", #to_be_compiled_files)
    end

    -- local tex_files = files.get_tex_files_with_status(root, config.output_formats, config.compilers)
    -- TODO: warn/error/compile if there are to_be_compiled files ?

    local needing_publication = {}
    local all_labels = {}
    local tex_xourses = {}
    for i, tex_file in ipairs(tex_files) do
        log:debug("Output for "..tex_file.absolute_path)
        needing_publication[#needing_publication + 1] = tex_file.relative_path

        local html_files = get_output_files(tex_file, "make4ht.html")
        
        for i,html_file in ipairs(html_files) do
        -- require 'pl.pretty'.dump(html_file)

            log:debug("Output for "..html_file.absolute_path)
            needing_publication[#needing_publication + 1] = html_file.relative_path

            local html_name = html_file.absolute_path
            local dom, msg = html.load_html(html_name)
            if not dom then 
                log:errorf("No dom for %s (%s). SKIPPING", html_name, msg)
                break
            end
        
            -- get all anchors (from \label)
            html_file.labels = html.get_labels(dom)
            
            -- merge them in a big table, to be added to metadata.json
            for k,v in pairs(html_file.labels) do 
                if all_labels[k] then
                    log:warningf("Label %s already used in %s; ignoring for %s",k, all_labels[k], html_file.relative_path)
                else
                    all_labels[k] = html_file.relative_path
                    log:tracef("Label %s added for %s",k,html_file.relative_path)
                end
            end

            local ass_files = html.get_associated_files(dom, html_file)

            table.move(ass_files, 1, #ass_files, #needing_publication + 1, needing_publication)


            html_file.associated_files = ass_files

            log:debug(string.format("Added %4d files for new total of %4d for %s", #ass_files+2,  #needing_publication, html_file.relative_path))
            -- require 'pl.pretty'.dump(to_be_compiled)

            -- Store xourses, they have to be added to metadata.json
            if tex_file.tex_type == "xourse" then
                log:info("Adding XOURSE "..tex_file.absolute_path.." ("..html_file.title..")")
                tex_xourses[html_file.basename] = { title = html_file.title, abstract = html_file.abstract } 
            end

        end
    end

    -- TODO: check/fix use of 'github'; check use of labels
    local xmmetadata={
        xakeVersion = "2.1.3",
        labels = all_labels,
        githubexample = {

            owner = "XimeraProject",
            repository = "ximeraExperimental"
        },
        github = {},
        xourses = tex_xourses,
    }


    save_as_json(xmmetadata)
    -- require 'pl.pretty'.dump(tex_xourses)

    needing_publication[#needing_publication + 1] = "metadata.json"

    -- 
    -- START FROSTING
    --

    local _, head_oid = osExecute("git rev-parse HEAD")
    if not head_oid then
        log:error("No headid returned by git rev-parse HEAD")
    end


    local publication_branch = "PUB_"..head_oid

    local ret, publication_oid = osExecute("git rev-parse --verify --quiet "..publication_branch)

    if ret > 0 then
        osExecute("git branch "..publication_branch)
        publication_oid = head_oid
    end
    log:debug("GOT publication_oid "..(publication_oid or ""))


    if path.exists("ximera-downloads") then
        -- needing_publication[#needing_publication + 1] = "ximera-downloads"
        osExecute("git add -f ximera-downloads")
    else 
        log:debug("No ximera-downloads folder, and thus no PDF files will be available for download")
    end
    -- require 'pl.pretty'.dump(needing_publication)

    -- 'git add' the files in batches of 10   (risks line-too-long!)
    -- local files_string = table.concat(needing_publication,",")
    -- Execute the git add command

    -- local downloads =  list_files("ximera-downloads")
    -- table.move(downloads, 1, #downloads, #needing_publication + 1, needing_publication)

if false then
    local f = io.open(".xmgitindexfiles", "w")

    for _, line in ipairs(needing_publication) do
        log:trace("ADDING "..line)
        f:write(line .. "\n")
    end
    f:close()
    -- Close the process to flush stdin and complete execution
    local proc = io.popen("cat .xmgitindexfiles | git update-index --add  --stdin")
    local output = proc:read("*a")
    local success, reason, exit_code = proc:close()

    if not success then
        log:errorf("git update-index fails with %s (%d)",reason, exit_code)
    else 
        log:debugf("Added %d files (%s)", #needing_publication,output)
    end

else    
    for _, line in ipairs(needing_publication) do
        log:trace("ADDING "..line)
        osExecute("git add -f "..line)
    end
end


    local _, new_tree = osExecute("git write-tree")
    if not new_tree then
        log:error("No tree returned by git write-tree")
    end
    log:debug("Made new tree ", new_tree)



    -- local tagName = "publications/"..head_oid

    -- result, tag_oid = osExecute("git for-each-ref --sort=-creatordate --count=1 --format '%(refname:strip=2)' refs/tags/publications/*")
    
    local result, most_recent_publication = osExecute("git for-each-ref --sort=-creatordate --count=1 --format '%(tree) %(objectname) %(refname:strip=2)' refs/tags/publications/*")

    if not most_recent_publication or most_recent_publication == "" then
        log:info("No publication found")
    else

        log:debugf("Got publication: %s",most_recent_publication)

    
        local tagtree_oid, tag_oid, tagName = most_recent_publication:match("([^%s]+) ([^%s]+) ([^%s]+)")

        log:infof("Found %s  (tree:%s tag:%s) ", tagName, tagtree_oid, tag_oid)

    end

    if tagtree_oid and tagtree_oid == new_tree then
        log:statusf("Tag "..tagName.." already exists (for %s)",tag_oid)
        return 0, 'OK'
    end
    
    -- -- Give a dummy account to push/commit if none is available
    -- ret, output = osExecute("git config  --get user.name  || { echo Setting git user.name;  git config --local user.name  'xmlatex Xake'; }")
    -- ret, output = osExecute("git config  --get user.email || { echo Setting git user.email; git config --local user.email 'xmlatex@xakecontainer'; }")

    local ret, commit_oid = osExecute("git commit-tree -m "..publication_branch.." -p "..publication_oid.." "..new_tree)
    if ret > 0 then
        return ret, commit_oid   -- this is the errormessage in this case!
    end
    log:debug("GOT commit "..(commit_oid or ""))
    
    if logging.show_level <= logging.levels["trace"] then
        log:tracef("Committed files for %s:", commit_oid)
        osExecute("git ls-tree -r --name-only "..commit_oid)
    end

    local ret, output = osExecute("git reset")

    -- TODO: check this, we might be creating too many commits/.. 
    if false and tagtree_oid then
        log:statusf("Updating tag %s for %s (was %s)", tagName, commit_oid, tag_oid)
        ret, output = osExecute("git update-ref refs/tags/"..tagName.." "..commit_oid)
    else
        --local tagName = "publications/"..os.date("%Y%m%d_%H%M%S")
        local tagName = "publications/"..commit_oid
        log:statusf("Creating tag %s for %s", tagName, commit_oid)
        ret, output = osExecute("git tag "..tagName.." "..commit_oid)
        -- if ret > 0 then
        --     log:errorf("Created tag %s for %s: %s", tagName, commit_oid, output)
        -- end
    end
    return ret, output
end

local function serve()

    local result, most_recent_publication = osExecute("git for-each-ref --sort=-creatordate --count=1 --format '%(tree) %(objectname) %(refname:strip=2)' refs/tags/publications/*")

    if not most_recent_publication or most_recent_publication == "" then
        log:warning("No publication tags found. Need 'frost' first?")
        return 1, 'No publications found'
    end

    log:debugf("Got publication: %s",most_recent_publication)

    
    local tree_oid, tag_oid, tagName = most_recent_publication:match("([^%s]+) ([^%s]+) ([^%s]+)")

    log:infof("Publishing  %s  (tree:%s tag:%s) ", tagName, tree_oid, tag_oid)
    
    osExecute("git push -f ximera "..tagName)
    osExecute("git push -f ximera "..tag_oid..":refs/heads/master")     -- HACK ???
    
    log:statusf("Published  %s", tagName)

    return 0,'OK'
end

M.get_output_files      = get_output_files
M.frost      = frost
M.serve      = serve

return M
