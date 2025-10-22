-- 获取Cargo.toml中的包名的函数
-- @param root_dir 项目根目录路径
-- @return 包名，如果未找到则返回nil和错误信息
local function get_cargo_package_name(root_dir)
	-- 确保根目录存在
	if not root_dir or root_dir == "" then
		return nil, "根目录路径不能为空"
	end

	-- 标准化路径，确保结尾有斜杠
	if not root_dir:match("/$") then
		root_dir = root_dir .. "/"
	end

	-- 检查Cargo.toml文件是否存在
	local cargo_path = root_dir .. "Cargo.toml"
	local file = io.open(cargo_path, "r")
	if not file then
		return nil, string.format("无法在 %s 找到Cargo.toml文件", root_dir)
	end

	-- 读取文件内容
	local content = file:read("*all")
	file:close()

	-- 查找[package]部分中的name字段
	-- 简单实现：查找[package]后的name = "值"
	local in_package_section = false

	-- 按行解析文件
	for line in content:gmatch("[^\r\n]+") do
		-- 检查是否进入了[package]部分
		if line:match("^%s*%[package%]%s*$") then
			in_package_section = true
		-- 检查是否离开了[package]部分（进入了新部分）
		elseif line:match("^%s*%[.+%]%s*$") then
			in_package_section = false
		-- 如果在[package]部分，查找name字段
		elseif in_package_section then
			local name = line:match('^%s*name%s*=%s*"([^"]+)"%s*$')
			if name then
				return name
			end
		end
	end

	return nil, "未能在Cargo.toml中找到包名"
end

return get_cargo_package_name
