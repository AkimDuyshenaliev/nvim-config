function getPythonPath()
  local python_venv_path = os.getenv('VIRTUAL_ENV') or os.getenv('CONDA_PREFIX')
  local pythonPath = python_venv_path and
                      ((vim.fn.has('win32') == 1 and
                      python_venv_path .. '/Scripts/python') or
                      python_venv_path .. '/bin/python') or
                      nil
  return pythonPath
end

require('dap-python').setup(getPythonPath())
table.insert(require('dap').configurations.python, {
  type = 'python',
  request = 'attach',
  name = 'Python: Docker Remote Attach',
  connect = function()
    local host = vim.fn.input('Host [127.0.0.1]: ')
    host = host ~= '' and host or '127.0.0.1'
    local port = tonumber(vim.fn.input('Port [5678]: ')) or 5678
    return { host = host, port = port }
  end;
  pathMappings = function()
    local localRoot = "${workspaceFolder}"
    local remoteRoot = vim.fn.input('Remote root [/base/]: ')
    remoteRoot = remoteRoot ~= '' and remoteRoot or '/base/'
    return { { localRoot = localRoot, remoteRoot = remoteRoot }, }
  end
})


-- Setup neotest
require("neotest").setup({
  adapters = {
    require("neotest-python")({
      runner = "pytest",
      python = getPythonPath(),
    })
  }
})
