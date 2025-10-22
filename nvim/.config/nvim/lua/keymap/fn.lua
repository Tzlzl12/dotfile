local M = {}

M.save = function ()
   local buffer_is_modified = vim.api.nvim_get_option_value("modified", { buf = 0 })
    if buffer_is_modified then
        vim.cmd "write"
    else
        print "Buffer not modified. No writing is done."
    end
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end


return M
