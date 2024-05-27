if not vim.g.vscode then
  return
end

---------------------------
-- Speedup dotrepeat sync
-- https://github.com/vscode-neovim/vscode-neovim/issues/1726#issuecomment-1872560374
---------------------------

local ok, internal = pcall(require, 'vscode-neovim.internal')
if not ok then
  internal = require 'vscode.internal'
end
local old_sync = internal.dotrepeat_sync
internal.dotrepeat_sync = function(edits, deletes)
  -- Only handle 500 changed characters and 200 deleted characters.
  if #edits > 500 then
    edits = edits:sub(#edits - 499)
  end
  deletes = math.min(deletes, 200)
  return old_sync(edits, deletes)
end
