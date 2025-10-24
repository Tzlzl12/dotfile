local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local dia = require("configs.icons").icons.dia
local separators = require("configs.heirline.common").separators
local dim = require("configs.heirline.common").dim
return {
	condition = conditions.has_diagnostics,
	update = { "DiagnosticChanged", "BufEnter" },
	on_click = {
		callback = function()
			require("trouble").toggle("diagnostics")
		end,
		name = "heirline_diagnostics",
	},
	init = function(self)
		self.diagnostics = vim.diagnostic.count()
	end,
	{
		provider = function(self)
			return self.diagnostics[1] and (dia.Error .. self.diagnostics[1] .. " ")
		end,
		hl = "DiagnosticError",
	},
	{
		provider = function(self)
			return self.diagnostics[2] and (dia.Warn .. self.diagnostics[2] .. " ")
		end,
		hl = "DiagnosticWarn",
	},
	{
		provider = function(self)
			return self.diagnostics[3] and (dia.Info .. self.diagnostics[3] .. " ")
		end,
		hl = "DiagnosticInfo",
	},
	{
		provider = function(self)
			return self.diagnostics[4] and (dia.Hint .. self.diagnostics[4] .. " ")
		end,
		hl = "DiagnosticHint",
	},
}
