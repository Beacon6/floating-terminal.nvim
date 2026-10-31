local M = {}

---@class (exact) State
---@field window integer ID of a window displaying the terminal
---@field bufnr  integer ID of a buffer containing terminal data
local state = {
    window = -1,
    bufnr  = -1
}

---@alias Border
---| "bold"
---| "double"
---| "none"
---| "rounded"
---| "shadow"
---| "single"
---| "solid"
---| string[]

---@alias Label string | string[][]

---@alias Position
---| "left"
---| "center"
---| "right"

---@class (exact) Config
---@field width_factor  number   | nil Percentage of screen width
---@field height_factor number   | nil Percentage of screen height
---@field border        Border   | nil Window border style
---@field title         Label    | nil Window title text
---@field title_pos     Position | nil Window title position
---@field footer        Label    | nil Window footer text
---@field footer_pos    Position | nil Window footer position
local config = {
    width_factor  = 0.8,
    height_factor = 0.8,
    border        = vim.o.winborder,
    title         = "",
    title_pos     = "left",
    footer        = "",
    footer_pos    = "left"
}

---@param opts Config | nil
---@return nil
M.setup = function(opts)
    if opts == nil then return end
    for k, v in pairs(opts) do
        config[k] = v
    end
end

---@return nil
M.toggle_floating_terminal = function()
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
        row = y,
        -- NOTE: Neovim type for "border" does not include "bold"
        ---@diagnostic disable-next-line: assign-type-mismatch
        border = config.border,
        title = config.title,
        title_pos = config.title_pos,
        footer = config.footer,
        footer_pos = config.footer_pos
    })
    if vim.api.nvim_get_option_value("buftype", { buf = state.bufnr }) ~= "terminal" then
        vim.cmd.term()
    end
end

vim.api.nvim_create_user_command("FloatingTerminal", function()
    M.toggle_floating_terminal()
end, {})

return M
