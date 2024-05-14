if not vim.g.vscode then
  return
end

----------------------------------
-- Clear all syntax highlighting --
----------------------------------

local api = vim.api

local function clear(group)
  api.nvim_set_hl(0, group, { link = 'VSCodeNone' })
end

local cleared = {}
local function clear_syntax(force)
  local output = api.nvim_exec2('syntax', { output = true })
  local items = vim.split(output.output, '\n')
  for _, item in ipairs(items) do
    local group = item:match [[([%w@%.]+)%s+xxx]]
    if group and (force or not cleared[group]) then
      cleared[group] = true
      clear(group)
    end
  end
end

api.nvim_create_autocmd({ 'FileType', 'Syntax', 'ColorScheme' }, {
  callback = function(ev)
    local is_colorscheme = ev.event == 'ColorScheme'
    clear_syntax(is_colorscheme)
    if is_colorscheme then
      vim.tbl_map(clear, vim.tbl_keys(cleared))
    end
  end,
  group = api.nvim_create_augroup('vscode-neovim-patch-clear-syntax', { clear = true }),
})
