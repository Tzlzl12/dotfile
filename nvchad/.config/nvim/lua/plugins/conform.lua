return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre", "BufNewFile" }, -- uncomment for format on save
    -- config = function()
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "ruff_format" },
        cpp = { "clang-format" },
        c = { "clang-format" },
        cs = { "clang-format" },
        json = { "jq" },
        javescript = { "deno_fmt" },
        typescript = { "deno_fmt" },
      },
      default_format_opts = {
        timeout_ms = 500,
      },
      formatters = {
        verible = {
          prepend_args = {
            "--column_limit=300",
            "--indentation_spaces=2",
            "--assignment_statement_alignment=align",
            "--named_port_alignment=align",
            "--port_declarations_alignment=align",
          },
        },
      },
    },
  },
}
