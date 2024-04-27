return {
  "mfussenegger/nvim-dap",
  enabled = vim.fn.has "win32" == 0,
  dependencies = {
    {
      "jay-babu/mason-nvim-dap.nvim",
      dependencies = { "nvim-dap" },
      cmd = { "DapInstall", "DapUninstall" },
      -- opts = { handlers = {} },
    },
    {
      "rcarriga/nvim-dap-ui",
      opts = {
        floating = {
          border = "rounded"
        },
        expand_lines = false,
        layouts = { {
            elements = { {
                id = "scopes",
                size = 0.60
              }, {
                id = "breakpoints",
                size = 0.30
              }, {
                id = "stacks",
                size = 0.05
              }, {
                id = "watches",
                size = 0.05
              } },
            position = "right",
            size = 60
          }, {
            elements = { {
                id = "repl",
                size = 0.75
              }, {
                id = "console",
                size = 0.25
              } },
            position = "bottom",
            size = 20
          } },
      },
      config = require "plugins.configs.nvim-dap-ui",
    },
    {
      "rcarriga/cmp-dap",
      dependencies = { "nvim-cmp" },
      config = require "plugins.configs.cmp-dap",
    },
  },
  event = "User AstroFile",
}
