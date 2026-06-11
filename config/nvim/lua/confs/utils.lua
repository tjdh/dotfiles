local M = {}

function M.map(mode, lhs, rhs, description, opts)
  local options = {desc = description}
  if opts then
    options = vim.tbl_extend("keep", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

function M.buf_map(mode, lhs, rhs, description, opts)
  local options = {buffer=true, desc = description}
  if opts then
    options = vim.tbl_extend("keep", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

function M.is_git_repo()
  vim.fn.system("git rev-parse --is-inside-work-tree")
  return vim.v.shell_error == 0
end

function M.get_git_root()
  local pwd = vim.fn.getcwd() .. ';'
  local dot_git_path = vim.fn.findfile(".git", pwd)
  if dot_git_path == "" then
    dot_git_path = vim.fn.finddir(".git", ".;")
  end
  return vim.fn.fnamemodify(dot_git_path, ":h")
end

function M.leave_visual_mode()
  local escKey = vim.api.nvim_replace_termcodes("<Esc>", false, true, true)
  vim.api.nvim_feedkeys(escKey, "nx", false)
end

return M
