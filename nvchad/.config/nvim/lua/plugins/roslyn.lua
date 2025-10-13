if vim.g.nvchad_lsp.roslyn == false then
  return {}
end

return {
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    dependencies = {
      "williamboman/mason.nvim",
      opts = { ensure_installed = { "netcoredbg" } },
    },

    opts = function()
      local opt = {
        -- your configuration comes here; leave empty for default settings
        ---@diagnostic disable-next-line: missing-fields
        config = {
          -- name = "roslyn",
          settings = {
            ["csharp|background_analysis"] = {
              dotnet_analyzer_diagnostics_scope = "openFiles",
              dotnet_compiler_diagnostics_scope = "openFiles",
            },
            ["csharp|completion"] = {
              dotnet_provide_regex_completions = true,
              dotnet_show_completion_items_from_unimported_namespaces = true,
              dotnet_show_name_completion_suggestions = true,
            },
            ["csharp|symbol_search"] = {
              dotnet_search_reference_assemblies = true,
            },
            ["csharp|inlay_hints"] = {
              csharp_enable_inlay_hints_for_implicit_object_creation = true,
              csharp_enable_inlay_hints_for_implicit_variable_types = true,
              csharp_enable_inlay_hints_for_lambda_parameter_types = true,
              csharp_enable_inlay_hints_for_types = true,
              dotnet_enable_inlay_hints_for_indexer_parameters = true,
              dotnet_enable_inlay_hints_for_literal_parameters = true,
              dotnet_enable_inlay_hints_for_object_creation_parameters = true,
              dotnet_enable_inlay_hints_for_other_parameters = true,
              dotnet_enable_inlay_hints_for_parameters = true,
              dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
              dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
              dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
            },
            ["csharp|code_lens"] = {
              dotnet_enable_references_code_lens = true,
              dotnet_enable_tests_code_lens = true,
            },
          },
        },
      }
      return opt
    end,

    config = function(_, opts)
      vim.lsp.config("rosly", opts.config)
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "Issafalcon/neotest-dotnet",
    },
    opts = function(_, opts)
      if not opts.adapters then
        opts.adapters = {}
      end

      table.insert(opts.adapters, require "neotest-dotnet" {})
    end,
  },
}
