local M = {}

local function pos_lt(a, b)
  if a[1] ~= b[1] then return a[1] < b[1] end
  return a[2] < b[2]
end

local function add(positions, seen, node)
  local row, col = node:range()
  local key = row * 1e6 + col
  if not seen[key] then
    seen[key] = true
    positions[#positions + 1] = { row, col }
  end
end

local function collect(bufnr, word)
  local parser = vim.treesitter.get_parser(bufnr)
  if not parser then return {} end
  local tree = parser:parse()[1]
  if not tree then return {} end

  local lang = parser:lang()
  local positions, seen = {}, {}

  if word ~= "" then
    local ok, q = pcall(vim.treesitter.query.get, lang, "locals")
    if ok and q then
      for id, node in q:iter_captures(tree:root(), bufnr, 0, -1) do
        if q.captures[id]:match("^local%.") and vim.treesitter.get_node_text(node, bufnr) == word then
          add(positions, seen, node)
        end
      end
    end
  end

  if #positions == 0 then
    local ok, q = pcall(vim.treesitter.query.parse, lang, "(function_declaration) @f (method_declaration) @f (function_definition) @f")
    if ok and q then
      for _, node in q:iter_captures(tree:root(), bufnr, 0, -1) do
        add(positions, seen, node)
      end
    end
  end

  table.sort(positions, pos_lt)
  return positions
end

local function jump(dir)
  local positions = collect(vim.api.nvim_get_current_buf(), vim.fn.expand("<cword>"))
  if #positions == 0 then return end

  local cur = vim.api.nvim_win_get_cursor(0)
  local cur_pos = { cur[1] - 1, cur[2] }

  local target
  if dir > 0 then
    for _, p in ipairs(positions) do
      if pos_lt(cur_pos, p) then target = p; break end
    end
    target = target or positions[1]
  else
    for i = #positions, 1, -1 do
      if pos_lt(positions[i], cur_pos) then target = positions[i]; break end
    end
    target = target or positions[#positions]
  end

  vim.cmd("normal! m'")
  vim.api.nvim_win_set_cursor(0, { target[1] + 1, target[2] })
end

function M.next() jump(1) end
function M.prev() jump(-1) end

return M
