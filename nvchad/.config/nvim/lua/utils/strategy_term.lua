local jobs = require "overseer.strategy._jobs"
local shell = require "overseer.shell"
local util = require "overseer.util"

---@class overseer.SnacksTermStrategy : overseer.Strategy
---@field private opts overseer.SnacksTermStrategyOpts
---@field private term? table
local SnacksTermStrategy = {}

---@class overseer.SnacksTermStrategyOpts
---@field use_shell? boolean load user shell before running task
---@field win? table window options (see snacks.terminal options)
---@field bo? table buffer options
---@field wo? table window options
---@field keys? table key mappings
---@field interactive? boolean whether terminal is interactive
---@field auto_scroll? boolean automatically scroll to the bottom on task output
---@field close_on_exit? boolean close terminal after task exits
---@field open_on_start? boolean open terminal automatically when task starts

---Run tasks using the snacks.terminal
---@param opts? overseer.SnacksTermStrategyOpts
---@return overseer.Strategy
function SnacksTermStrategy.new(opts)
  opts = vim.tbl_extend("keep", opts or {}, {
    use_shell = false,
    win = {
      position = "float",
      width = 0.8,
      height = 0.8,
    },
    bo = {},
    wo = {},
    keys = {},
    interactive = true,
    auto_scroll = true,
    close_on_exit = false,
    open_on_start = true,
  })

  local strategy = {
    opts = opts,
    term = nil,
  }
  setmetatable(strategy, { __index = SnacksTermStrategy })
  ---@type overseer.SnacksTermStrategy
  return strategy
end

function SnacksTermStrategy:reset()
  if self.term then
    self.term:close()
    self.term = nil
  end
end

function SnacksTermStrategy:get_bufnr()
  return self.term and self.term.buf
end

---@param task overseer.Task
function SnacksTermStrategy:start(task)
  local mode = vim.api.nvim_get_mode().mode
  local stdout_iter = util.get_stdout_line_iter()

  local function on_stdout(data)
    task:dispatch("on_output", data)
    local lines = stdout_iter(data)
    if not vim.tbl_isempty(lines) then
      task:dispatch("on_output_lines", lines)
    end
  end

  local cmd = task.cmd
  if type(cmd) == "table" then
    cmd = shell.escape_cmd(cmd, "strong")
  end

  -- Prepare command for snacks.terminal
  local term_cmd
  if self.opts.use_shell then
    -- If using shell, we'll send the command after terminal creation
    term_cmd = nil
  else
    term_cmd = cmd
  end

  -- Create terminal options
  local term_opts = vim.tbl_deep_extend("force", {
    cmd = term_cmd,
    cwd = task.cwd,
    env = task.env,
    interactive = self.opts.interactive,
    win = self.opts.win,
    bo = self.opts.bo,
    wo = self.opts.wo,
    keys = self.opts.keys,
  }, {})

  -- Create the terminal
  local ok, snacks = pcall(require, "snacks")
  if not ok then
    error "snacks.nvim is not available"
  end

  self.term = snacks.terminal(term_opts)

  if not self.term then
    error "Failed to create snacks terminal"
  end

  -- Register job if we have a job_id
  if self.term.job_id then
    jobs.register(self.term.job_id)
  end

  -- Set up output handling
  if self.term.on_stdout then
    self.term.on_stdout = function(data)
      on_stdout(data)
    end
  end

  -- Set up exit handling
  if self.term.on_exit then
    local original_on_exit = self.term.on_exit
    self.term.on_exit = function(code, signal)
      -- Call original handler first
      if original_on_exit then
        original_on_exit(code, signal)
      end

      -- Unregister job
      if self.term.job_id then
        jobs.unregister(self.term.job_id)
      end

      -- Feed one last line end to flush the output
      on_stdout { "" }

      if vim.v.exiting == vim.NIL then
        task:on_exit(code or 0)
      end

      if self.opts.close_on_exit then
        self.term:close()
      end
    end
  end

  -- Handle shell command sending
  if self.opts.use_shell and cmd then
    -- Schedule command sending to ensure terminal is ready
    vim.schedule(function()
      if self.term and self.term.send then
        self.term:send(cmd)
        -- Send exit command to capture exit code
        local exit_cmd = "exit " .. (vim.o.shell:find "fish" and "$status" or "$?")
        self.term:send(exit_cmd)
      end
    end)
  end

  -- Open terminal if requested
  if self.opts.open_on_start then
    self.term:show()
  end

  util.hack_around_termopen_autocmd(mode)
end

function SnacksTermStrategy:stop()
  if self.term and self.term.job_id then
    vim.fn.jobstop(self.term.job_id)
  elseif self.term and self.term.pid then
    -- Try to kill by PID if job_id is not available
    vim.fn.system("kill " .. self.term.pid)
  end
end

function SnacksTermStrategy:dispose()
  if self.term then
    self.term:close()
    self.term = nil
  end
end

---Open the terminal with specific window configuration
---@param win_opts? table window options to override
function SnacksTermStrategy:open_terminal(win_opts)
  if self.term then
    if win_opts then
      -- Update window options and show
      self.term.opts.win = vim.tbl_deep_extend("force", self.term.opts.win or {}, win_opts)
    end
    self.term:show()
  end
end

---Toggle the terminal visibility
function SnacksTermStrategy:toggle_terminal()
  if self.term then
    self.term:toggle()
  end
end

---Hide the terminal
function SnacksTermStrategy:hide_terminal()
  if self.term then
    self.term:hide()
  end
end

return SnacksTermStrategy
