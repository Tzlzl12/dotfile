if not vim.g.neovide then
  print "not found"
  return {}
end

-- vim.g.transparency = 0.88
-- vim.g.neovide_background_color = ("#0f1117" .. string.format("%x", math.floor(((255 * vim.g.transparency) or 0.8))))
vim.g.neovide_increment_scale_factor = vim.g.neovide_increment_scale_factor or 0.1
vim.g.neovide_min_scale_factor = vim.g.neovide_min_scale_factor or 0.7
vim.g.neovide_max_scale_factor = vim.g.neovide_max_scale_factor or 2.0
vim.g.neovide_initial_scale_factor = vim.g.neovide_scale_factor or 1
vim.g.neovide_scale_factor = vim.g.neovide_scale_factor or 1

-- Clamps the scale factor within the min and max bounds
---@param scale_factor number
---@return number
local function clamp_scale_factor(scale_factor)
  return math.max(math.min(scale_factor, vim.g.neovide_max_scale_factor), vim.g.neovide_min_scale_factor)
end

-- Sets the Neovide scale factor, optionally clamping the value
---@param scale_factor number
---@param clamp? boolean
local function set_scale_factor(scale_factor, clamp)
  vim.g.neovide_scale_factor = clamp and clamp_scale_factor(scale_factor) or scale_factor
end

-- Resets the Neovide scale factor to its initial value
local function reset_scale_factor()
  vim.g.neovide_scale_factor = vim.g.neovide_initial_scale_factor
end

-- Increments or decrements the scale factor by a specified amount
---@param increment number
---@param clamp? boolean
local function change_scale_factor(increment, clamp)
  set_scale_factor(vim.g.neovide_scale_factor + increment, clamp)
end

-- Define autocommands to react to scale factor changes or other events

-- Auto-cmd to handle scale factor reset or change when certain events occur
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Set initial scale factor if not already set
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor or vim.g.neovide_initial_scale_factor
    -- Apply scaling or reset if needed on startup
    if vim.g.neovide_scale_factor ~= vim.g.neovide_initial_scale_factor then
      set_scale_factor(vim.g.neovide_scale_factor, true)
    end
  end,
})

-- Auto-cmd to reset scale factor when the window is resized (you can change this to your preferred event)
vim.api.nvim_create_autocmd("VimResized", {
  callback = function()
    -- Optional: You could reset scale factor based on specific criteria when resizing
    -- For now, it's just an example, so we're keeping it simple
    reset_scale_factor()
  end,
})

-- Register custom commands for setting and resetting the scale factor
vim.api.nvim_create_user_command("NeovideSetScaleFactor", function(event)
  local scale_factor, option = tonumber(event.fargs[1]), event.fargs[2]

  if not scale_factor then
    vim.notify(
      "Error: scale factor argument is nil or not a valid number.",
      vim.log.levels.ERROR,
      { title = "Recipe: neovide" }
    )
    return
  end

  set_scale_factor(scale_factor, option ~= "force")
end, { nargs = "+", desc = "Set Neovide scale factor" })

vim.api.nvim_create_user_command("NeovideResetScaleFactor", reset_scale_factor, { desc = "Reset Neovide scale factor" })

-- Key mappings for increasing, decreasing, and resetting the scale factor
vim.api.nvim_set_keymap(
  "n",
  "<C-=>",
  "<Cmd>lua change_scale_factor(vim.g.neovide_increment_scale_factor * vim.v.count1, true)<CR>",
  { noremap = true, desc = "Increase Neovide scale factor" }
)
vim.api.nvim_set_keymap(
  "n",
  "<C-->",
  "<Cmd>lua change_scale_factor(-vim.g.neovide_increment_scale_factor * vim.v.count1, true)<CR>",
  { noremap = true, desc = "Decrease Neovide scale factor" }
)
vim.api.nvim_set_keymap(
  "n",
  "<C-0>",
  "<Cmd>lua reset_scale_factor()<CR>",
  { noremap = true, desc = "Reset Neovide scale factor" }
)
