--  fetch the api and keymap modules from the Neovim Lua API
local api = vim.api
local keymap = vim.keymap

local hlslens = require("hlslens")

-- Configures the behavior of the hlslens plugin by enabling options like calm_down and nearest_only.
hlslens.setup {
  calm_down = true,
  nearest_only = true,
}

local activate_hlslens = function(direction)
-- if the user inputs 5j to move the cursor down 5 lines, vim.v.count1 would return 5.
  local cmd = string.format("normal! %s%szzzv", vim.v.count1, direction)
--    The pcall function is a Lua function that stands for "protected call." It attempts to execute the specified function and handles any errors that might occur during execution. If the function executes successfully, pcall returns true; otherwise, it returns false along with an error message.

  local status, msg = pcall(vim.cmd, cmd)

  -- Deal with the case that there is no such pattern in current buffer.
  if not status then
    local start_idx, _ = string.find(msg, 'E486', 1, true)
    local msg_part = string.sub(msg, start_idx)
    api.nvim_err_writeln(msg_part)
    return
  end

  hlslens.start()
end

keymap.set("n", "n", "", {
  callback = function()
    activate_hlslens("n")
  end,
})

keymap.set("n", "N", "", {
  callback = function()
    activate_hlslens("N")
  end,
})

keymap.set("n", "*", "", {
  callback = function()
    vim.fn.execute("normal! *N")
    hlslens.start()
  end,
})
keymap.set("n", "#", "", {
  callback = function()
    vim.fn.execute("normal! #N")
    hlslens.start()
  end,
})
