local function choiceColorBaseOnDay(len)
  local day = os.date("%d")
  return day % len
end

function ColorMyPencils(color, i)
  local colors = {
    'ayu-dark',
    'flexoki-dark',
    'rose-pine',
    'tokyonight-night',
    'kanagawa',
    'poimandres',
    'midnight',
  }
  if i then
    color = colors[i]
  end

  if color or i then
    print('Setting colorscheme to ' .. (color or ''))
  end

  color = color or colors[choiceColorBaseOnDay(#colors)]
  -- color = color or "catppuccin-mocha"
  vim.cmd.colorscheme(color)


  --	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils()
