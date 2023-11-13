-- This is my personal Nvim configuration supporting Mac, Linux and Windows, with various plugins configured.
-- This configuration evolves as I learn more about Nvim and become more proficient in using Nvim.
-- Since it is very long (more than 1000 lines!), you should read it carefully and take only the settings that suit you.
-- I would not recommend cloning this repo and replace your own config. Good configurations are personal,
-- built over time with a lot of polish.
--
-- Author: Jiedong Hao
-- Email: jdhao@hotmail.com
-- Blog: https://jdhao.github.io/
-- GitHub: https://github.com/jdhao
-- StackOverflow: https://stackoverflow.com/users/6064933/jdhao

-- This function is used to enable loading plugins or components. It seems you're enabling the loading of certain components or functionality in your Neovim configuration.
vim.loader.enable()

-- check if we have the latest stable version of nvim
local version = vim.version
local expected_ver = "0.9.4"
local ev = version.parse(expected_ver)
local actual_ver = version()

-- If the Neovim version is not the expected version.
if version.cmp(ev, actual_ver) ~= 0 then
  local _ver = string.format("%s.%s.%s", actual_ver.major, actual_ver.minor, actual_ver.patch)
  local msg = string.format("Expect nvim %s, but got %s instead. Use at your own risk!", expected_ver, _ver)
  vim.api.nvim_err_writeln(msg)
end

local core_conf_files = {
  "globals.lua", -- some global settings
  "options.vim", -- setting options in nvim
  "autocommands.vim", -- various autocommands
  "mappings.lua", -- all the user-defined mappings
  "plugins.vim", -- all the plugins installed and their configurations
  "colorschemes.lua", -- colorscheme settings
}

-- vim.fn.stdpath("config"): This portion retrieves the path of the Neovim configuration directory. 
-- vim.fn.stdpath() is a Neovim API function that fetches standard directories for configuration, data, and other purposes.
-- .. "/viml_conf": The .. operator is used for string concatenation in Lua. This part is appending /viml_conf to the path retrieved in the first step. It seems like you're creating a new directory named viml_conf inside your Neovim configuration directory.
-- This method allows you to create a separate subdirectory (viml_conf) within your Neovim configuration directory to organize or store additional VimL scripts or related configuration files.
local viml_conf_dir = vim.fn.stdpath("config") .. "/viml_conf"

-- source all the core config files
--  to perform a sequence of operations based on a list of core_conf_files.
-- Looping through core_conf_files:
for _, file_name in ipairs(core_conf_files) do
  -- Checks if the file has a .vim extension
  if vim.endswith(file_name, 'vim') then
    -- If the file ends with .vim, it constructs the full path to the file using viml_conf_dir and the file name
    local path = string.format("%s/%s", viml_conf_dir, file_name)
    -- then executes the source command in Neovim to load and execute the VimL configuration file
    local source_cmd = "source " .. path
    vim.cmd(source_cmd)
  -- If the file does not have a .vim extension, it is assumed to be a Lua module. 
  else
    -- It manipulates the file_name to extract the module name
    -- denotes a literal dot followed by "lua") within the file_name string and replaces it with an empty string.
    local module_name, _ = string.gsub(file_name, "%.lua", "")
    -- and then reloads the Lua module
    -- When a module is loaded in Lua, it is cached in the package.loaded table. Setting it to nil effectively unloads or unregisters the module from the package.loaded table. 
    -- It's a technique often used during development to refresh or update the behavior of a Lua module without restarting the entire Neovim application
    package.loaded[module_name] = nil
    require(module_name)
  end
end
