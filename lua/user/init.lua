return {
  colorscheme = "kanagawa-wave",
  plugins = {
    "~/.config/nvim/lua/user/plugins/colorscheme",
    "~/.config/nvim/lua/user/plugins/heirline",
    "~/.config/nvim/lua/user/plugins/nvim-dap-python",
    "~/.config/nvim/lua/user/plugins/lsp-zero",
    "~/.config/nvim/lua/user/plugins/nvim-jdtls",
    "~/.config/nvim/lua/user/plugins/nvim-dap-ui",
    "~/.config/nvim/lua/user/plugins/neotest",
    "~/.config/nvim/lua/user/plugins/nvim-dap-repl-highlights",
    "~/.config/nvim/lua/user/plugins/vim-dadbod-ui",
  },
  lsp = {
    formatting = {
      format_on_save = false, -- enable or disable automatic formatting on save
    },
  },
}
