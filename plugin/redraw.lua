if not vim.g.vscode then
  return
end

-------------------------------------------------------------------
-- Redraw the whole screen to fix potiential highlighting issues --
-------------------------------------------------------------------

local timer
local function redraw()
  if timer and timer:is_active() then
    timer:close()
  end
  timer = vim.defer_fn(vim.cmd.mode, 200)
end

vim.api.nvim_create_autocmd({
  'CursorHold',
  'TextChanged',
  'InsertLeave',
}, {
  callback = redraw,
})
