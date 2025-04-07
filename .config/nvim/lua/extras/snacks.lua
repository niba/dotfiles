local M = {}

M.layouts = {
  vscode = {
    preview = false,
    layout = {
      backdrop = false,
      row = 1,
      width = 0.4,
      min_width = 80,
      height = 0.4,
      border = "rounded",
      box = "vertical",
      {
        win = "input",
        height = 1,
        border = "bottom",
        title = "{title} {live} {flags}",
        title_pos = "center",
      },
      { win = "list", border = "hpad" },
      { win = "preview", title = "{preview}", border = "rounded" },
    },
  },
}

function M.flash(picker)
  require("flash").jump({
    pattern = "^",
    label = { after = { 0, 0 } },
    search = {
      mode = "search",
      exclude = {
        function(win)
          return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
        end,
      },
    },
    action = function(match)
      local idx = picker.list:row2idx(match.pos[1])
      picker.list:_move(idx, true, true)
      -- you can also add auto confirm here
    end,
  })
end

-- we want to use sort that works like zf, not fzf
function M.zf_sorter(picker, fields)
  local normalized_fields = {} ---@type snacks.picker.sort.Field[]
  for _, f in ipairs(fields or { { name = "score", desc = true }, "idx" }) do
    if type(f) == "string" then
      local desc, len = false, nil
      if f:sub(1, 1) == "#" then
        f, len = f:sub(2), true
      end
      if f:sub(-5) == ":desc" then
        f, desc = f:sub(1, -6), true
      elseif f:sub(-4) == ":asc" then
        f = f:sub(1, -5)
      end
      table.insert(normalized_fields, { name = f, desc = desc, len = len })
    else
      table.insert(normalized_fields, f)
    end
  end

  -- print(picker.source .. " " .. vim.inspect(normalized_fields))
  -- example of fields = { "score:desc", "#text", "idx" }

  if picker.source == "recent" or picker.source == "buffers" then
    local function abs(n)
      return n < 0 and -n or n
    end
    local TOO_FAR = 5
    return function(a, b)
      local av, bv = a.score, b.score

      if av ~= bv then
        return av > bv
      end

      av, bv = a.idx, b.idx

      if abs(av - bv) < TOO_FAR then
        return av < bv
      end

      av, bv = a.text, b.text
      av, bv = a.filename and #a.filename or #av, b.filename and #b.filename or bv

      if av ~= bv then
        return av < bv
      end

      return a.idx < b.idx
    end
  end

  return function(a, b)
    for _, field in ipairs(normalized_fields) do
      local av, bv = a[field.name], b[field.name]
      if av ~= nil and bv ~= nil then
        if field.len then
          av, bv = #av, #bv
        end
        if av ~= bv then
          if field.desc then
            return av > bv
          else
            return av < bv
          end
        end
      end
    end
    return false
  end
end

return M
