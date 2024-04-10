return {
  colorscheme = "kanagawa-wave",
  plugins = {
    {
      "rebelot/kanagawa.nvim", -- colorscheme
      name = "kanagawa",
    },
    {
      "rebelot/heirline.nvim",
      opts = function(_, opts)
        local status = require "astronvim.utils.status"

        opts.winbar = { -- create custom winbar
          -- store the current buffer number
          init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
          fallthrough = false, -- pick the correct winbar based on condition
          -- inactive winbar
          {
            condition = function() return not status.condition.is_active() end,
            -- show the path to the file relative to the working directory
            status.component.separated_path { path_func = status.provider.filename { modify = ":.:h" } },
            -- add the file name and icon
            status.component.file_info {
              file_icon = { hl = status.hl.file_icon "winbar", padding = { left = 0 } },
              file_modified = false,
              file_read_only = false,
              hl = status.hl.get_attributes("winbarnc", true),
              surround = false,
              update = "BufEnter",
            },
          },
          -- active winbar
          {
            -- show the path to the file relative to the working directory
            status.component.separated_path { path_func = status.provider.filename { modify = ":.:h" } },
            -- add the file name and icon
            status.component.file_info { -- add file_info to breadcrumbs
              file_icon = { hl = status.hl.filetype_color, padding = { left = 0 } },
              file_modified = false,
              file_read_only = false,
              hl = status.hl.get_attributes("winbar", true),
              surround = false,
              update = "BufEnter",
            },
            -- show the breadcrumbs
            status.component.breadcrumbs {
              icon = { hl = true },
              hl = status.hl.get_attributes("winbar", true),
              prefix = true,
              padding = { left = 0 },
            },
          },
        }
        return opts
      end,
    },
    {
      "mfussenegger/nvim-dap-python",
      dependencies = {
        "mfussenegger/nvim-dap",
      },
    },
    {
      "rcarriga/nvim-dap-ui",
      config = function(plugin, opts)
        -- run default AstroNvim nvim-dap-ui configuration function
        require "plugins.configs.nvim-dap-ui"(plugin, opts)

        -- disable dap events that are created
        local dap = require "dap"
        dap.listeners.after.event_initialized["dapui_config"] = nil
        dap.listeners.before.event_terminated["dapui_config"] = nil
        dap.listeners.before.event_exited["dapui_config"] = nil
      end,
    },
    {
      "nvim-neotest/neotest",
      dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-neotest/neotest-python",
      },
    },
    {
      "LiadOz/nvim-dap-repl-highlights",
    },
    {
      "tpope/vim-dadbod",
      dependencies = {
        "kristijanhusak/vim-dadbod-completion",
        "kristijanhusak/vim-dadbod-ui",
      },
    },
  },
  lsp = {
    formatting = {
      format_on_save = false, -- enable or disable automatic formatting on save
    },
  },
}
