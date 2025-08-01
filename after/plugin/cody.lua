if true then return end
if not module_exists("sg") then return end

sg = require"sg"

  sg.setup {
    enable_cody = true,
    event = 'InsertEnter',
  }

