local M = {}

---@class (exact) State
---@field window integer ID of a window displaying the terminal
---@field bufnr  integer ID of a buffer containing terminal data

---@class Config
---@field width_factor  number Percentage of screen width
---@field height_factor number Percentage of screen height

---@type State
local state = {
    window = -1,
    bufnr  = -1
}

---@type Config
local defaults = {
    width_factor  = 0.8,
    height_factor = 0.8
}

---@type Config
local config

---@generic T
---@param field T
---@param default T
---@return T
local function get(field, default)
    if field ~= nil then
        return field
    end
    return default
end

---@param opts Config
function M:setup(opts)
    config.height_factor = get(opts.height_factor, defaults.height_factor)
    config.height_factor = get(opts.height_factor, defaults.height_factor)
end

function M:toggle_floating_terminal()
    if vim.api.nvim_win_is_valid(state.window) then
        vim.api.nvim_win_hide(state.window)
        state.window = -1
        return
    end

    if not vim.api.nvim_buf_is_valid(state.bufnr) then
        state.bufnr = vim.api.nvim_create_buf(false, true)
    end

    local width = math.floor(vim.o.columns * config.width_factor)
    local height = math.floor(vim.o.lines * config.height_factor)

    local x = math.floor((vim.o.columns - width) / 2)
    local y = math.floor((vim.o.lines - height) / 2)

    state.window = vim.api.nvim_open_win(state.bufnr, true, {
        relative = "editor",
        width = width,
        height = height,
        col = x,
        row = y
    })
    if vim.api.nvim_get_option_value("buftype", { buf = state.bufnr }) ~= "terminal" then
        vim.cmd.term()
    end
end

vim.api.nvim_create_user_command("FloatingTerminal", function()
    M:toggle_floating_terminal()
end, {})

return M
