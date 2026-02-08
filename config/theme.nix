{
  extraConfigLua = ''
    -- Personal theme
    require('accent').setup({
      accent_color = 'orange',
      custom_accent = {
        fg = '#009CD9',
        bg = '#0077A6',
        ctermfg = 196,
        ctermbg = 124,
      },
      accent_darken = false,
      invert_status = false,
      auto_cwd_color = false,
      no_bg = true,
    })
    vim.cmd.colorscheme('accent')
  '';
}
