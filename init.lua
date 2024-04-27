if vim.loader and vim.fn.has "nvim-0.9.1" == 1 then vim.loader.enable() end

for _, source in ipairs {
  "astronvim.bootstrap",
  "astronvim.options",
  "astronvim.lazy",
  "astronvim.autocmds",
  "astronvim.mappings",
} do
  local status_ok, fault = pcall(require, source)
  if not status_ok then vim.api.nvim_err_writeln("Failed to load " .. source .. "\n\n" .. fault) end
end

if astronvim.default_colorscheme then
  if not pcall(vim.cmd.colorscheme, astronvim.default_colorscheme) then
    require("astronvim.utils").notify(
      ("Error setting up colorscheme: `%s`"):format(astronvim.default_colorscheme),
      vim.log.levels.ERROR
    )
  end
end
-- End of default configurations

-- Nvim options configuration
vim.o.scrolloff = 15
vim.o.termguicolors = true -- Color settings for alacritty+tmux
vim.g.diagnostics_mode = 2 -- Set diagnostics mode

-- Enable transparancy
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })


-- Setup mason
require("mason").setup()
require("astronvim.utils").conditional_func(astronvim.user_opts("polish", nil, false), true)

-- Setup DAP
require ('mason-nvim-dap').setup({
  ensure_installed = { "python", "sh", "java" },
  automatic_installation = true,
})
require('nvim-dap-repl-highlights').setup()
---@diagnostic disable-next-line: missing-fields
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    "python", "dap_repl", "java",
    "groovy", "cpp", "go", "json",
    "toml", "yaml", "sql", "bash",
  },
  sync_install = false,
  highlight = {
    enable = true,
  },
}

-- DAP Configurations
local python_venv_path = os.getenv('VIRTUAL_ENV') or os.getenv('CONDA_PREFIX')
local pythonPath = python_venv_path and ((vim.fn.has('win32') == 1 and python_venv_path .. '/Scripts/python') or python_venv_path .. '/bin/python') or nil

require('dap-python').setup(pythonPath)

-- Setup neotest
require("neotest").setup({
  adapters = {
    require("neotest-python")({
      runner = "pytest",
      python = pythonPath,
    })
  }
})
require("neodev").setup({
  library = {
    plugins = { "neotest" },
    types = true,
  },
})

