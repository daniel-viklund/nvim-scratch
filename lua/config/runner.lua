-- A project runner for arbitrary shell commands. Terminal 4 is its output.
local M = {}
local api = vim.api
local current, pending
local quitting = false
local pump

local function notify(message, level)
  vim.notify(message, level or vim.log.levels.INFO, { title = "Project runner" })
end

local function project_root()
  if current and api.nvim_get_current_buf() == current.term.bufnr then
    return current.root
  end
  local root = vim.fs.root(0, ".git") or vim.fn.getcwd()
  return vim.fs.normalize(vim.uv.fs_realpath(root) or root)
end

local function config_path(root)
  return vim.fs.joinpath(vim.fn.stdpath("data"), "project-runner", vim.fn.sha256(root) .. ".json")
end

local function read_config(root)
  local path = config_path(root)
  if vim.fn.filereadable(path) == 0 then
    return { build = "", run = "", cwd = "." }
  end
  local ok, config = pcall(function()
    return vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
  end)
  if not ok or type(config) ~= "table"
    or type(config.build) ~= "string" or type(config.run) ~= "string"
    or type(config.cwd) ~= "string" then
    notify("Invalid runner settings: " .. path, vim.log.levels.ERROR)
    return
  end
  return config
end

local function working_directory(root, value)
  local path = vim.fs.normalize(value == "" and "." or value)
  if not path:match("^/") and not path:match("^%a:[/\\]") then
    path = vim.fs.joinpath(root, path)
  end
  return vim.fs.normalize(path)
end

local function configure(root, done)
  local config = read_config(root)
  if not config then return end
  local fields = {
    { "build", "Build command (blank to skip): " },
    { "run", "Run command (blank for build only): " },
    { "cwd", "Working directory (relative to " .. root .. "): ", "dir" },
  }
  local function prompt(index)
    local field = fields[index]
    if field then
      vim.ui.input({ prompt = field[2], default = config[field[1]], completion = field[3] }, function(value)
        if value == nil then return end
        config[field[1]] = vim.trim(value)
        prompt(index + 1)
      end)
      return
    end
    if vim.fn.isdirectory(working_directory(root, config.cwd)) == 0 then
      notify("Working directory does not exist", vim.log.levels.ERROR)
      return
    end
    config.root = root
    local path = config_path(root)
    local ok, err = pcall(function()
      vim.fn.mkdir(vim.fs.dirname(path), "p")
      assert(vim.fn.writefile({ vim.json.encode(config) }, path) == 0, "Could not save settings")
    end)
    if not ok then
      notify(tostring(err), vim.log.levels.ERROR)
      return
    end
    notify("Saved commands for " .. root)
    if done then done(config) end
  end
  prompt(1)
end

function M.configure()
  configure(project_root())
end

local function stop_current()
  if not current then return end
  -- Cancel a queued build -> run transition as well as a running process.
  current.cancelled = true
  if current.running and not current.stopping then
    current.stopping = true
    vim.fn.jobstop(current.term.job_id)
  end
end

function M.stop()
  pending = nil
  stop_current()
end

pump = function()
  if quitting or not pending or (current and current.running) then return end
  local request = pending
  pending = nil
  local terminals = require("toggleterm.terminal")
  local occupied = terminals.get(4, true)
  if occupied and (not current or occupied ~= current.term) then
    notify("Terminal 4 is in use. Close its shell with exit before using the runner.", vim.log.levels.WARN)
    return
  end
  if current then current.term:shutdown() end

  local state = { root = request.root, running = true }
  current = state
  state.term = terminals.Terminal:new({
    count = 4,
    cmd = request.config[request.phase],
    dir = request.cwd,
    direction = "horizontal",
    display_name = request.phase .. " · " .. vim.fs.basename(request.root),
    close_on_exit = false,
    on_exit = function(_, _, code)
      state.running = false
      -- ToggleTerm finishes its TermClose handling before a replacement starts.
      vim.schedule(function()
        if quitting or current ~= state then return end
        if not state.cancelled then
          if code ~= 0 then
            notify(request.phase .. " exited with code " .. code, vim.log.levels.ERROR)
          elseif request.phase == "build" then
            notify("Build succeeded")
            if request.run_after then
              pending = vim.tbl_extend("force", request, { phase = "run", run_after = false })
            end
          end
        end
        pump()
      end)
    end,
  })

  local ok, err = pcall(function() state.term:open() end)
  if not ok or not state.term.job_id or state.term.job_id <= 0 then
    state.running = false
    state.cancelled = true
    notify("Could not start command: " .. tostring(err or "terminal did not start"), vim.log.levels.ERROR)
    return
  end
  -- Show output while keeping editing shortcuts available in the source window.
  vim.schedule(function()
    if current == state and api.nvim_win_is_valid(request.window)
      and api.nvim_get_current_win() == state.term.window
      and api.nvim_win_get_buf(request.window) ~= state.term.bufnr then
      api.nvim_set_current_win(request.window)
      vim.cmd.stopinsert()
    end
  end)
end

function M.execute(action)
  assert(action == "build" or action == "run" or action == "build_run", "Unknown runner action")
  local root = project_root()
  local window = api.nvim_get_current_win()
  local config = read_config(root)
  if not config then return end
  local function start(settings)
    local phase = action == "build" and "build" or "run"
    if action == "build_run" and settings.build ~= "" then phase = "build" end
    if settings[phase] == "" or (action == "build_run" and settings.run == "") then
      notify("Command is empty. Configure it with <leader>tc.", vim.log.levels.WARN)
      return
    end
    local cwd = working_directory(root, settings.cwd)
    if vim.fn.isdirectory(cwd) == 0 then
      notify("Working directory does not exist: " .. cwd, vim.log.levels.ERROR)
      return
    end
    pending = {
      root = root, config = settings, cwd = cwd, window = window,
      phase = phase, run_after = action == "build_run" and phase == "build",
    }
    stop_current()
    pump()
  end
  local needs_config = (action == "build" and config.build == "")
    or (action ~= "build" and config.run == "")
  if needs_config then configure(root, start) else start(config) end
end

function M.toggle()
  if current and current.term.bufnr and api.nvim_buf_is_valid(current.term.bufnr) then
    -- Keep the object even after exit: ToggleTerm removes finished jobs from its registry.
    current.term:toggle()
  else
    notify("No runner output yet. Use <leader>tr to run or <leader>tb to build.")
  end
end

function M.setup()
  local mappings = {
    { "pb", function() M.execute("build") end, "Build project" },
    { "pr", function() M.execute("run") end, "Run/restart project" },
    { "pR", function() M.execute("build_run") end, "Build and run project" },
    { "px", M.stop, "Stop project" },
    { "pc", M.configure, "Configure project commands" },
    { "t4", M.toggle, "Terminal 4: project output" },
  }
  for _, mapping in ipairs(mappings) do
    vim.keymap.set("n", "<leader>" .. mapping[1], mapping[2], { desc = mapping[3] })
  end
  api.nvim_create_autocmd("VimLeavePre", {
    group = api.nvim_create_augroup("ProjectRunner", { clear = true }),
    callback = function()
      quitting = true
      M.stop()
    end,
  })
end

return M
