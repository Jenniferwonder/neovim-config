-- In Neovim's Lua API, vim.fn provides access to various built-in Vimscript functions that can be called from Lua.
local fn = vim.fn
-- vim.api gives access to various Neovim API functions to interact with buffers, windows, and other editor components programmatically
local api = vim.api
-- The require function is used to load external Lua modules or scripts. In this case, it's loading a module named 'utils', which is likely a custom Lua module that contains utility functions or specific functionalities designed to be used within this Neovim Lua configuration.
-- "C:\Users\amazi\AppData\Local\nvim\lua\utils.lua"
local utils = require('utils')

-- Inspect something
function _G.inspect(item)
  vim.print(item)
end

------------------------------------------------------------------------
--                          custom variables                          --
------------------------------------------------------------------------
-- If the system has "win32" or "win64" features (indicating a Windows OS), it sets is_win to true; otherwise, it sets it to false.
vim.g.is_win = (utils.has("win32") or utils.has("win64")) and true or false
vim.g.is_linux = (utils.has("unix") and (not utils.has("macunix"))) and true or false
vim.g.is_mac  = utils.has("macunix") and true or false

vim.g.logging_level = "info"

------------------------------------------------------------------------
--                         builtin variables                          --
------------------------------------------------------------------------
vim.g.loaded_perl_provider = 0  -- Disable perl provider
vim.g.loaded_ruby_provider = 0  -- Disable ruby provider
vim.g.loaded_node_provider = 1  -- UnDisable node provider
-- to signal that the default menus have been installed or loaded, and some parts of the configuration or plugins might depend on this flag for further logic or functionality (? 0, 1 doesn't make much change)
vim.g.did_install_default_menus = 1  -- do not load menu

-- Check if python3 exist
-- In init.vim: `let g:python3_host_prog='D:/Users/amazi/AppData/Local/Programs/Python/Python311/python.exe'`
-- In init.lua: `vim.g.python3_host_prog ='D:/Users/amazi/AppData/Local/Programs/Python/Python311/python.exe'`
if utils.executable('python3') then
  if vim.g.is_win then
    -- For Windows (vim.g.is_win is true), it sets vim.g.python3_host_prog to the path of the Python 3 executable without the .exe extension.
    vim.g.python3_host_prog = fn.substitute(fn.exepath("python3"), ".exe$", '', 'g')
  else
    -- For non-Windows systems, it directly sets vim.g.python3_host_prog to the path of the Python 3 executable.
    vim.g.python3_host_prog = fn.exepath("python3")
  end
else
  -- prints an error message to the Neovim message line
  api.nvim_err_writeln("Python3 executable not found! You must install Python3 and set its PATH correctly!")
  -- exits the current script execution
  return
end

-- Custom mapping <leader> (see `:h mapleader` for more info)
vim.g.mapleader = ','

-- Enable highlighting for lua HERE doc inside vim script
vim.g.vimsyn_embed = 'l'

-- Use English as main language
vim.cmd [[language en_US.UTF-8]]

-- Disable loading certain plugins

-- Whether to load netrw by default, see https://github.com/bling/dotvim/issues/4
-- This prevents Netrw from loading by indicating that it is already loaded (1), and thus it won't be initialized when starting Vim/Neovim.
vim.g.loaded_netrw       = 1
vim.g.loaded_netrwPlugin = 1
vim.g.netrw_liststyle = 3
if vim.g.is_win then
  vim.g.netrw_http_cmd = "curl --ssl-no-revoke -Lo"
end

-- Do not load tohtml.vim
vim.g.loaded_2html_plugin = 1

-- Do not load zipPlugin.vim, gzip.vim and tarPlugin.vim (all these plugins are
-- related to checking files inside compressed files)
vim.g.loaded_zipPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_tarPlugin = 1

-- Do not load the tutor plugin
vim.g.loaded_tutor_mode_plugin = 0

-- Do not use builtin matchit.vim and matchparen.vim since we use vim-matchup
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1

-- Disable sql omni completion, it is broken.
vim.g.loaded_sql_completion = 1
