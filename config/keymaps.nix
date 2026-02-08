{
  keymaps = [
    {
      mode = [
        "n"
        "x"
      ];
      key = "gy";
      action = "\"+y";
      options.desc = "Copy to clipboard";
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "gp";
      action = "\"+p";
      options.desc = "Paste clipboard content";
    }
    {
      mode = "n";
      key = "[d";
      action.__raw = "vim.diagnostic.goto_prev";
      options.desc = "Prev diagnostic";
    }
    {
      mode = "n";
      key = "]d";
      action.__raw = "vim.diagnostic.goto_next";
      options.desc = "Next diagnostic";
    }
    {
      mode = "n";
      key = "<leader>ld";
      action.__raw = "vim.diagnostic.open_float";
      options.desc = "Line diagnostics";
    }
  ];

  extraConfigLua = ''
    require('which-key').setup({
      icons = {
        mappings = false,
        keys = {
          Space = 'Space',
          Esc = 'Esc',
          BS = 'Backspace',
          C = 'Ctrl-',
        },
      },
    })

    require('which-key').add({
      { '<leader>f', group = 'Fuzzy Find' },
      { '<leader>b', group = 'Buffer' },
      { '<leader>l', group = 'LSP' },
      { '<leader>d', group = 'Diagnostics' },
      { 'g', group = 'Goto/LSP' },
    })
  '';
}
