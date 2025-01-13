return {
  'blazkowolf/gruber-darker.nvim',
  opts = {
    italic = {
      strings = false,
      comments = false,
      operators = false,
      folds = false,
    },
  },
  priority = 1000,
  init = function()
    vim.cmd.colorscheme 'gruber-darker'
  end,
}
