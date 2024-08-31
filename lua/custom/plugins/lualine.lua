--NOTE: LUALINE
return {
  'nvim-lualine/lualine.nvim',
  dependencies = {
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    require('lualine').setup {
      options = {
        icons_enabled = false,
        theme = 'monokai-pro',
      },
    }
  end,
}
