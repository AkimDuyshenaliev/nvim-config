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
  ensure_installed = { "python" },
  automatic_installation = true,
})
require('nvim-dap-repl-highlights').setup()
---@diagnostic disable-next-line: missing-fields
require('nvim-treesitter.configs').setup {
  ensure_installed = {"python", "dap_repl", "java", "cpp", "go", "json", "toml", "yaml", "sql" },
  sync_install = false,
  highlight = {
    enable = true,
  },
}

-- Setup neotest
local venv_path = os.getenv('VIRTUAL_ENV') or os.getenv('CONDA_PREFIX')
require("neotest").setup({
  adapters = {
    require("neotest-python")({
      runner = "pytest",
      python = venv_path and ((vim.fn.has('win32') == 1 and venv_path .. '/Scripts/python') or venv_path .. '/bin/python') or nil,
    })
  }
})
require("neodev").setup({
  library = {
    plugins = { "neotest" },
    types = true,
  },
})

-- DAP Configurations
if vim.fn.filereadable(string.format("%s/.vscode/launch.json", vim.fn.getcwd())) == 1 then
  require('dap.ext.vscode').load_launchjs(nil, { debugpy = {'python'}, cppdbg = {'c', 'cpp'} })

  -- The bellow but only if launch.json has 1 configuration, more than 1 will confuse the DAP
  local function generate_python_attach_adapter(config)
    return {
        type = 'server',
        id = config.name or 'Python: Default Attach',
        host = config.connect.host or 'localhost',
        port = tonumber(config.connect.port) or 5678,
    }
  end

  -- local function generate_python_attach_config(config)
  --   local venv_path = os.getenv('VIRTUAL_ENV') or os.getenv('CONDA_PREFIX')
  --   return {
  --     type = config.type;
  --     request = config.request;
  --     name = config.name;
		--   pythonPath = venv_path and ((vim.fn.has('win32') == 1 and venv_path .. '/Scripts/python') or venv_path .. '/bin/python') or nil,
  --   }
  -- end

  -- local function starts_with(str, prefix)
  --   local pattern = "^" .. prefix
  --   return string.find(str, pattern) ~= nil
  -- end

  local dap = require("dap")
  local launchConfig = vim.fn.json_decode(vim.fn.readfile(".vscode/launch.json"))

  for _, config in ipairs(launchConfig.configurations) do

    -- A "good idea" I think, but doesn't exactly work, needs fixing (IT NEEDS UNIQUE TYPE IN THE launch.json CONFIGURATIONS! ! ! ! !)
    -- if starts_with(config.type, "debugpy") then
      -- dap.configurations[config.type] = generate_python_attach_config(config)
      -- dap.run(config)

    if config.type == 'python' and config.request == 'attach' then
      dap.adapters[config.type] = generate_python_attach_adapter(config)
    end
  end
end

