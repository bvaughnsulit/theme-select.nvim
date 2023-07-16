local arg = vim.g.set_scheme

local M = {}

M.setup = function(opts)
  -- specify theme directly with --cmd arg
  if type(arg) == 'string' then
    vim.cmd('colorscheme ' .. arg)
  elseif arg == true then
    -- trigger propmt to select theme on startup
    local available_schemes = vim.fn.getcompletion('', 'color')
    vim.cmd 'colorscheme habamax'

    -- provide a list of themes to exclude from selection list
    local filtered_schemes = vim.tbl_filter(function(e)
      if vim.tbl_contains(opts.exclude, e) then
        return false
      else
        return true
      end
    end, available_schemes)

    local schemes_to_add = vim.tbl_keys(opts.add)
    vim.list_extend(filtered_schemes, schemes_to_add, 1, #schemes_to_add)

    vim.ui.select(filtered_schemes, {}, function(input)
      if input == nil then
        return
      -- use custom setup function if added theme
      elseif vim.tbl_contains(schemes_to_add, input) then
        opts.add[input].setup()
      else
        vim.cmd('colorscheme ' .. input)
      end
    end)
  end
  return true
end

return M
