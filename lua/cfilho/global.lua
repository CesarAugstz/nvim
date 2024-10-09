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

-- Print the result (for debugging purposes)
if vim.g.gitcz_installed then
  print("Node.js dependency " .. dependency_name .. " is installed in the project.")
else
  print("Node.js dependency " .. dependency_name .. " is not installed in the project.")
end

