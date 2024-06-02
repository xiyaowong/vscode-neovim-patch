if not vim.g.vscode then
  return
end

local fn, api = vim.fn, vim.api

local vscode = require 'vscode'

if vim.tbl_contains(vim.tbl_keys(vscode), 'with_insert') then
  return
end

vscode.with_insert = function(callback)
  vim.validate { callback = { callback, 'f' } }

  local mode = api.nvim_get_mode().mode

  local startinsert = function(keys)
    keys = api.nvim_replace_termcodes(keys, true, true, true)
    api.nvim_feedkeys(keys, 'n', false)
  end

  ---@param ranges lsp.Range[]|nil`
  local run_callback = function(ranges)
    if ranges then
      vscode.action('start-multiple-cursors', { args = { ranges }, callback = callback })
    else
      vscode.action('noop', { callback = callback })
    end
  end

  --- Insert ---
  if mode == 'i' then
    run_callback()
    return
  end

  --- Normal ---
  if mode == 'n' then
    startinsert 'a'
    run_callback()
    return
  end

  --- Visual ---
  if mode:match '[vV\x16]' then
    local A = fn.getpos 'v'
    local B = fn.getpos '.'
    local start_pos = { A[2], A[3] - 1 }
    local end_pos = { B[2], B[3] - 1 }

    if start_pos[1] > end_pos[1] or (start_pos[1] == end_pos[1] and start_pos[2] > end_pos[2]) then
      start_pos, end_pos = end_pos, start_pos
    end

    if mode == 'V' then
      start_pos = { start_pos[1], 0 }
      end_pos = { end_pos[1], #fn.getline(end_pos[1]) }
    end

    local range = vim.lsp.util.make_given_range_params(start_pos, end_pos, 0, 'utf-16').range
    local ranges = { range }

    api.nvim_win_set_cursor(0, end_pos)
    startinsert '<Esc>a'

    run_callback(ranges)
    return
  end

  --- Other ---
  startinsert '<Esc><Esc>a'
  run_callback()
end
