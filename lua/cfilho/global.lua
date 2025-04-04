-- Function to check if a Node.js dependency is installed in the project
function CheckProjectNodeDependency(dependency)
  local project_root = vim.fn.getcwd() -- Get the current working directory
  local dependency_path = project_root .. "/node_modules/" .. dependency
  local file = io.open(dependency_path, "r")
  if file then
    file:close()
    return true
  else
    return false
  end
end

-- Check if 'dependency_name' is installed in the project
local dependency_name = "git-cz"
vim.g.gitcz_installed = CheckProjectNodeDependency(dependency_name)

function module_exists(module_name, log)
  log = log or false
  local status, _ = pcall(require, module_name)
  if not log and not status then print( module_name .. " is not installed") end
  return status
end

