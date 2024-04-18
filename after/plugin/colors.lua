local colors = {
  'ayu-dark',
  -- 'flexoki-dark', n funciona direito
  'rose-pine',
  -- 'tokyonight-night', usei mt, testar outras
  -- 'kanagawa', mt fraca as cores
  -- 'poimandres', cor branca, e poucas cores
  'midnight',
}

local function choiceColorBaseOnDay(len)
  local day = os.date("%d")
  return (day % len) + 1
end

function WichColor()
  print('Color: ' .. (colors[choiceColorBaseOnDay(#colors)] or 'Fail to get color'))
end

function ColorMyPencils(color, i)
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
