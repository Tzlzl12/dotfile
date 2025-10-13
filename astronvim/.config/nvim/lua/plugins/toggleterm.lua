return {
  "akinsho/toggleterm.nvim",
  cmd = { "ToggleTerm", "TermExec" },
  specs = {
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        local astro = require "astrocore"
        if vim.fn.executable "git" == 1 and vim.fn.executable "gitui" == 1 then
          maps.n["<Leader>g"] = vim.tbl_get(opts, "_map_sections", "g")
          local gitui = {
            callback = function()
              local worktree = astro.file_worktree()
              local flags = worktree and (" --work-tree=%s --git-dir=%s"):format(worktree.toplevel, worktree.gitdir)
                or ""
              astro.toggle_term_cmd { cmd = "gitui " .. flags, direction = "float" }
            end,
            desc = "ToggleTerm lazygit",
          }
          maps.n["<Leader>gg"] = { gitui.callback, desc = gitui.desc }
          maps.n["<Leader>tl"] = { gitui.callback, desc = gitui.desc }
        end
      end,
    },
  },
}
