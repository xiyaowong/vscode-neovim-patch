if not vim.g.vscode then
  return
end

-------------------------------------------------------------------
-- Redraw the whole screen to fix potiential highlighting issues --
-------------------------------------------------------------------

vim.api.nvim_create_autocmd({ 'CursorHold', 'TextChanged', 'InsertLeave' }, {
  callback = function()
    vim.defer_fn(vim.cmd.mode, 100)
  end,
})
