return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    explorer = { enabled = true },
    notifier = {
        enabled = true,
    },
    indent = {
        enabled = true,
    },
    input = {
        enabled = true,
    },
    statuscolumn = {
    },
  },
}
