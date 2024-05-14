if not vim.g.vscode then
  return
end

-------------------------------------------------------------------
-- Redraw the whole screen to fix potiential highlighting issues --
-------------------------------------------------------------------

local ns = vim.api.nvim_create_namespace 'vscode_neovim_custom_redraw_ns'

local timer
local redrawed = false
local function on_win()
  if timer and timer:is_active() then
    timer:close()
  end

  timer = vim.defer_fn(function()
    redrawed = not redrawed
    if redrawed then
      vim.cmd.mode()
    end
  end, 3000)
end

vim.api.nvim_set_decoration_provider(ns, { on_win = on_win })
