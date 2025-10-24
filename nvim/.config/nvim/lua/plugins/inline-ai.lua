return {
	{
		"Exafunction/windsurf.nvim",
		cmd = "Codeium",
		event = "InsertEnter",
		lazy = true,
		build = ":Codeium Auth",
		opts = {
			enable_cmp_source = false,
			virtual_text = {
				enabled = true,
				idle_delay = 200,
				key_bindings = {
					accept = false, -- handled by nvim-cmp / blink.cmp
					next = "<M-]>",
					prev = "<M-[>",
				},
			},
		},
		config = function(_, opts)
			require("codeium").setup(opts)
		end,
	},
}
