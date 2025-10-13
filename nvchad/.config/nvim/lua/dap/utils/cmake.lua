-- 获取CMake项目名称的函数
-- @param root_dir 项目根目录路径
-- @return 项目名称，如果未找到则返回nil和错误信息
local function get_cmake_project_name(root_dir)
  -- 确保根目录存在
  if not root_dir or root_dir == "" then
    return nil, "根目录路径不能为空"
  end

  -- 标准化路径，确保结尾有斜杠
  if not root_dir:match "/$" then
    root_dir = root_dir .. "/"
  end

  -- 检查CMakeLists.txt文件是否存在
  local cmake_path = root_dir .. "CMakeLists.txt"
  local file = io.open(cmake_path, "r")
  if not file then
    return nil, string.format("无法在 %s 找到CMakeLists.txt文件", root_dir)
  end

  -- 读取文件内容
  local content = file:read "*all"
  file:close()

  -- 查找项目名变量定义（如 set(CMAKE_PROJECT_NAME dominos)）
  local cmake_project_var_name, cmake_project_var_value

  -- 查找 set(CMAKE_PROJECT_NAME value) 格式
  cmake_project_var_name, cmake_project_var_value =
    content:match "set%s*%(([cC][mM][aA][kK][eE]_[pP][rR][oO][jJ][eE][cC][tT]_[nN][aA][mM][eE])%s+([%w_%-]+)%s*%)"

  -- 追踪变量引用的项目名
  local project_var_ref

  -- 查找 project(${CMAKE_PROJECT_NAME}) 格式
  project_var_ref = content:match "project%s*%(%${([%w_%-]+)}[%)%s]"

  -- 检查是否找到了变量引用，并且该变量有定义
  if project_var_ref and cmake_project_var_name and project_var_ref == cmake_project_var_name then
    return cmake_project_var_value
  end

  -- 查找直接指定的project指令
  -- 匹配以下格式:
  -- project(ProjectName)
  -- project(ProjectName VERSION x.y.z)
  -- project(ProjectName LANGUAGES CXX)
  -- project(ProjectName VERSION x.y.z LANGUAGES CXX)
  local project_name = content:match "project%s*%(([%w_%-]+)[%)%s]"
    or content:match "project%s*%(([%w_%-]+)%s+[vV][eE][rR][sS][iI][oO][nN]"
    or content:match "project%s*%(([%w_%-]+)%s+[lL][aA][nN][gG][uU][aA][gG][eE][sS]"

  if project_name then
    return project_name
  end

  -- 如果找到了CMAKE_PROJECT_NAME但没有在project()中引用，也返回它
  if cmake_project_var_value then
    return cmake_project_var_value
  end

  return nil, "未能在CMakeLists.txt中找到project指令或项目名称"
end

return get_cmake_project_name
