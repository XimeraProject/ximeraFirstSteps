local M = {}
local lfs = require "lfs"
local error_logparser = require("make4ht-errorlogparser")
local pl = require "penlight"
local path = pl.path
local pldir = pl.dir
local plfile = pl.file
local html = require "luaxake-transform-html"
local files = require "luaxake-files"      -- for get_metadaa
local socket = require "socket"

local log = logging.new("compile")



-- --- fill command template with file information
-- --- @param file metadata file on which the command should be run
-- --- @param command string command template
-- --- @return string command 
-- local function prepare_command(file, command_template)
--   -- replace placeholders like @{filename} with the corresponding keys from the metadata table
--   return command_template:gsub("@{(.-)}", file)
-- end


local function test_log_file(filename)
  local f = io.open(filename, "r")
  if not f then 
    log:error("Cannot open log file: " .. filename)
    return nil 
  end
  local content = f:read("*a")
  f:close()
  return error_logparser.parse(content)
end

local function copy_table(tbl)
  local t = {}
  for k,v in pairs(tbl) do 
    if type(v) == "table" then
      t[k] = copy_table(v)
    else
      t[k] = v 
    end
  end
  return t
end

-- Function to find the first table with a given key/value using Penlight
local function find_entry(array, key, value)
  for _, entry in ipairs(array) do
      if entry[key] == value then

          return entry  -- Return the first matching entry
      end
  end
  return nil  -- Return nil if no match is found
end

--
-- These next functions are/can be called by post_command in config.commands
-- HACK: these currently need to be global; TODO: fix!
--
function process_html(file)
  -- simple wrapper to make it work in post_command
  --
  return html.process(file)
end

function move_to_downloads(file, cmd_meta, root_dir)
  -- move the pdf to a corresponding folder under root_dir (presumably ximera-downloads, with different path/name!)
  --
  local folder = string.format("%s/%s/%s",root_dir, cmd_meta.download_folder, file.dir)
  
  -- require 'pl.pretty'.dump(cmd_meta)
  -- require 'pl.pretty'.dump(file)
  local src = find_entry(file.output_files, "extensionlong", cmd_meta.extension)

  if not src or src == ""  then
    log:errorf("No extensionlong = %s found for %s",cmd_meta.extension, file.relative_path)
    require 'pl.pretty'.dump(file)
  end
  -- local src = file.output_files[1].absolute_path    -- TODO: fix
  
  local tgt = string.format("%s/%s.%s", folder, file.basename, src.extension)
  -- require 'pl.pretty'.dump(src)
  if src and path.exists(src.absolute_path) then
    log:infof("Moving %s to %s", src.absolute_path, tgt)
    pldir.makepath(folder)
    plfile.copy(src.absolute_path, tgt)
  else
    log:warningf("No output file found for ",file.relative_path)
  end
  return 1, 'NOK'
end

--
--
--


--- run a complete compile-cycle on a given file
--- 
--- SIDE-EFFECT: adds output_files to the file argiument !!!
--- 
--- @param file metadata file on which the command should be run
--- @param compilers [compiler] list of compilers
--- @param compile_sequence table sequence of keys from the compilers table to be executed
--- @return [compile_info] statuses information from the commands
local function compile(file, compilers, compile_sequence, only_check)
  only_check = only_check or false
  --
  -- WARNING: (tex-)compilation HAS TO START IN THE SUBFOLDER !!!
  --   !!! CHDIR  might confuse all relative paths !!!!
  --
  local current_dir = lfs.currentdir()
  log:tracef("Changing directory to %s (for actual compilations, from %s)",file.absolute_dir,current_dir)
  lfs.chdir(file.absolute_dir)

  local statuses = {}

  -- Start ALL compilations for this file, in the correct order; stop as soon as one fails...
  -- NOTE: extension is a bad name, it's rather  'compiler'
  for _, extension in ipairs(compile_sequence) do
    local command_metadata = compilers[extension]

    if not command_metadata then
      log:errorf("No compiler defined for %s (%s); SKIPPING",extension,file.relative_path)
      goto endofthiscompilation  -- nice: a goto-statement !!!
    end
    if file.extension ~= "tex" then
      log:errorf("Can't compile non-tex file %s; SKIPPING, SHOULD PROBABLY NOT HAVE HAPPENED",file.relative_path)
      goto endofthiscompilation  -- nice: a goto-statement !!!
    end

     local infix = ""
    if command_metadata.infix and command_metadata.infix ~= "" then
      infix = command_metadata.infix.."."
    end
    local output_file = file.filename:gsub("tex$", extension)
    local log_file    = file.filename:gsub("tex$", infix.."log")

    -- sometimes compiler wants to check for the output file (like for sagetex.sage),
    if command_metadata.check_file and not path.exists(output_file) then
      log:debugf("Skipping compilation because 'check_file' and file %s does not exist",output_file)
      goto endofthiscompilation  -- nice: a goto-statement !!!
    end
    
    -- if not output_file.needs_compilation then
    --   log:debugf("Skipping compilation file %s is uptodate",output_file)
    --   goto endofthiscompilation  -- nice: a goto-statement !!!
    -- end

    
      -- NOT NEEDED ???
      -- local command_template = command_metadata.command
      -- we need to make a copy of file metadata to insert some additional fields without modification of the original
      -- log:debug("Command " .. command_template)
      -- local tpl_table = copy_table(file)
      -- tpl_table.output_file = output_file
      -- tpl_table.make4ht_extraoptions = config.make4ht_extraoptions
      -- tpl_table.make4ht_mode = config.make4ht_mode
      -- local command = prepare_command(tpl_table, command_template)

      -- replace placeholders like @{filename} with the corresponding keys from the metadata table
      file.output_file = output_file    -- for potential substitution as @{output_file} in command:
      local command = command_metadata.command:gsub("@{(.-)}", file)
            command = command:gsub("@{(.-)}", config)
      file.output_file = nil

      local start_time =  socket.gettime()
      local compilation_time = 0
      local status = 0
      local output = ""

      if only_check then
        log:info("Running in check-modus: SKIPPING " .. command )
      else
        log:info("Running " .. command )
        -- we reuse this file from make4ht's mkutils.lua
        local f = io.popen(command, "r")
        output = f:read("*all")
        -- rc will contain return codes of the executed command
        local rc =  {f:close()}
        -- the status code is on the third position 
        -- https://stackoverflow.com/a/14031974/2467963
        status = rc[3]
        local end_time = socket.gettime()
        compilation_time = end_time - start_time

        if status ~= command_metadata.status then
          -- error will be handled and properly logged further down!
          log:errorf("Compilation of %s for %s failed: returns %d (not %d) after %3f seconds", extension, file.relative_path, status, command_metadata.status,compilation_time)
        end
      end


      --- @class compile_info
      --- @field output_file string output file name
      --- @field command string executed command
      --- @field output string stdout from the command
      --- @field status number status code returned by command
      --- @field errors? table errors detected in the log file
      --- @field post_status? boolean did HTML processing run without errors?
      --- @field post_message? string possible error message from HTML post-processing
      local compile_info = {
        output_file = output_file,
        command     = command,
        output      = output,
        status      = status
      }
      if command_metadata.check_log then
        compile_info.errors = test_log_file(log_file)  -- gets errors the make4ht-way !
        for _, err in ipairs(compile_info.errors) do
          log:errorf("%-20s: %s [[%s]]", err.filename or "?", err.error, err.context)
        end
      end

    if status == command_metadata.status then

      -- store outputfiles with metadata
      -- log:infof("ADDING METADATA FOR %s : %s (from %s)",current_dir, output_file, file.absolute_dir)
      local ofile = files.get_metadata(file.absolute_dir, output_file)

      log:debug("Adding outputfile "..ofile.relative_path.. " to "..file.relative_path)
      -- require 'pl.pretty'.dump(ofile)
      table.insert(file.output_files,ofile) 
      -- require 'pl.pretty'.dump(file)

      if command_metadata.post_command then
        local cmd = command_metadata.post_command
        log:infof("Postprocessing: %s", cmd)

        -- call the post_command
        compile_info.post_status, compile_info.post_message = _G[cmd](file, command_metadata, current_dir)     -- lua way of calling the function whose name is in 'cmd'
        
        if not compile_info.post_status then
          log:error("Error in HTML post processing: " .. compile_info.post_message)
        end
      end

    else
        if path.exists(output_file) then
          -- prevent  trailing non-correct files, as they prevent automatic re-compilation !
          log:debugf("Moving failed output file to %s",output_file..".failed")
          pl.file.move(output_file,output_file..".failed")
        end
    end
      table.insert(statuses, compile_info)

      log:info(string.format("Compilation of %s took %.1f seconds (%.20s)", output_file, compilation_time, file.title))

      if status == command_metadata.fatal_status then
        log:warning("Skipping further compilations for %s after error",file.relative_file)
        break   -- STOP FURTHER COMPILATION
      end
    --end
    log:tracef("Ended compilation %s", extension)
    ::endofthiscompilation::
  end
  lfs.chdir(current_dir)

  -- if dump_metadata then
  --   log:debug("Dumping new metadata for ".. relative_file )
  --   require 'pl.pretty'.dump(metadata)
  -- end

  return statuses
end


--- print error messages parsed from the LaTeX log
---@param errors table
local function print_errors(statuses)
  for _, status in ipairs(statuses) do
    local errors = status.errors or {}
    if #errors > 0 then
      log:error("Errors from " .. status.command .. ":")
      for _, err in ipairs(errors) do
        log:errorf("%20s line %s: %s", err.filename or "?", err.line or "?", err.error)
        log:error(err.context)
      end
    end
  end
end

--- remove temporary files
---@param basefile metadata 
---@param extensions table    list of extensions of files to be removed
---@return  number nfiles     number of files removed
local function clean(basefile, extensions, only_check)
  only_check = only_check or false
  local nfiles = 0
  local basename = path.splitext(basefile.absolute_path)
  log:tracef("%s temp files for %s (%s)", (only_check and "Would remove" or "Removing"), basename, basefile.absolute_path)
  for _, ext in ipairs(extensions) do
    local filename = basename .. "." .. ext
    if path.exists(filename) then
      log:debugf("%s  %s file %s", (only_check and "Would remove" or "Removing") ,ext, filename)
      if not only_check then os.remove(filename); nfiles = nfiles + 1 end
    end
  end
  return nfiles
end

M.compile      = compile
M.print_errors = print_errors
M.clean        = clean

return M
