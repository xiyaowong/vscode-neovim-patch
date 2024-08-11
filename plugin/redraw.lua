if not vim.g.vscode then
  return
end

-------------------------------------------------------------------
-- Redraw the whole screen to fix potiential highlighting issues --
-------------------------------------------------------------------

local timer
local function redraw(delay)
  if timer and timer:is_active() then
    timer:close()
  end
  timer = vim.defer_fn(vim.cmd.mode, delay)
end

vim.api.nvim_create_autocmd({ 'CursorHold', 'TextChanged' }, {
  callback = function(ev)
    if ev.event:match 'TextChanged' then
      redraw(1000)
    else
      redraw(300)
    end
  end,
})
