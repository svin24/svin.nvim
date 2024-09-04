return {
  'shaunsingh/nord.nvim',
  init = function()
    vim.cmd.colorscheme 'nord'
  end,
}

-- return {
--   'neanias/everforest-nvim',
--   version = false,
--   lazy = false,
--   priority = 1000, -- make sure to load this before all the other start plugins
--   -- Optional; default configuration will be used if setup isn't called.
--   init = function()
--     vim.cmd.colorscheme 'everforest'
--   end,
-- }
--
-- return {
--    'loctvl842/monokai-pro.nvim',
--    init = function()
--      vim.cmd.colorscheme 'monokai-pro'
--    end,
--    config = function()
--      require('monokai-pro').setup {
--        transparent_background = true,
--        terminal_colors = true,
--      }
--    end,
--  }
