local M = {}

M._state = {
    window = -1,
    bufnr = -1
}

function M:toggle_floating_terminal()
    if vim.api.nvim_win_is_valid(self._state.window) then
        vim.api.nvim_win_hide(self._state.window)
        self._state.window = -1
        return
    end

    if not vim.api.nvim_buf_is_valid(self._state.bufnr) then
        self._state.bufnr = vim.api.nvim_create_buf(false, true)
    end

    local width = math.floor(vim.o.columns * 0.6)
    local height = math.floor(vim.o.lines * 0.6)

    local x = math.floor((vim.o.columns - width) / 2)
    local y = math.floor((vim.o.lines - height) / 2)

    self._state.window = vim.api.nvim_open_win(self._state.bufnr, true, {
        relative = "editor",
        width = width,
        height = height,
        col = x,
        row = y
    })
    if vim.api.nvim_get_option_value("buftype", { buf = self._state.bufnr }) ~= "terminal" then
        vim.cmd.term()
    end
end

vim.api.nvim_create_user_command("FloatingTerminal", function()
    M:toggle_floating_terminal()
end, {})

return M
