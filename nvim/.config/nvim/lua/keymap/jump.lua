local map = vim.keymap.set

local function diagnostic_goto(dir, severity)
	local go = vim.diagnostic["goto_" .. (dir and "next" or "prev")]
	if type(severity) == "string" then
		severity = vim.diagnostic.severity[severity]
	end
	return function()
		go({ severity = severity })
	end
end

if vim.fn.has("nvim-0.11") == 0 then
	map("n", "[d", diagnostic_goto(false), { desc = "Jump Previous diagnostic" })
	map("n", "]d", diagnostic_goto(true), { desc = "Jump Next diagnostic" })
end
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Jump Previous error" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Jump Next error" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Jump Previous warning" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Jump Next warning" })

map("n", "]q", vim.cmd.cnext, { desc = "Jump Next quickfix" })
map("n", "[q", vim.cmd.cprev, { desc = "Jump Previous quickfix" })
map("n", "]Q", vim.cmd.clast, { desc = "Jump End quickfix" })
map("n", "[Q", vim.cmd.cfirst, { desc = "Jump Beginning quickfix" })

map("n", "]l", vim.cmd.lnext, { desc = "Jump Next loclist" })
map("n", "[l", vim.cmd.lprev, { desc = "Jump Previous loclist" })
map("n", "]L", vim.cmd.llast, { desc = "Jump End loclist" })
map("n", "[L", vim.cmd.lfirst, { desc = "Jump Beginning loclist" })
