{
  keymaps = [
    {
      mode = "n";
      key = "<leader>bc";
      action = "<cmd>lua pcall(MiniBufremove.delete)<cr>";
      options.desc = "Close buffer";
    }
    {
      mode = "n";
      key = "<leader>e";
      action.__raw = ''
        function()
          local mini_files = require('mini.files')
          if mini_files.close() then
            return
          end
          mini_files.open()
        end
      '';
      options.desc = "File explorer";
    }
    {
      mode = "n";
      key = "<leader>?";
      action = "<cmd>Pick oldfiles<cr>";
      options.desc = "Search file history";
    }
    {
      mode = "n";
      key = "<leader><space>";
      action = "<cmd>Pick buffers<cr>";
      options.desc = "Search open files";
    }
    {
      mode = "n";
      key = "<leader>ff";
      action = "<cmd>Pick files<cr>";
      options.desc = "Search all files";
    }
    {
      mode = "n";
      key = "<leader>fg";
      action = "<cmd>Pick grep_live<cr>";
      options.desc = "Search in project";
    }
    {
      mode = "n";
      key = "<leader>fd";
      action = "<cmd>Pick diagnostic<cr>";
      options.desc = "Search diagnostics";
    }
    {
      mode = "n";
      key = "<leader>fs";
      action = "<cmd>Pick buf_lines<cr>";
      options.desc = "Buffer local search";
    }
  ];

  extraConfigLua = ''
    require('mini.icons').setup({ style = 'ascii' })
    require('mini.ai').setup({ n_lines = 500 })
    require('mini.comment').setup({})
    require('mini.surround').setup({})
    require('mini.bufremove').setup({})
    require('mini.files').setup({})
    require('mini.pick').setup({})
    require('mini.extra').setup({})
    require('mini.snippets').setup({})
    require('mini.completion').setup({})
  '';
}
