{
  plugins.which-key = {
    enable = true;
    settings = {
      icons = {
        mappings = false;
        keys = {
          Space = "Space";
          Esc = "Esc";
          BS = "Backspace";
          C = "Ctrl-";
        };
      };

      spec = [
        {
          __unkeyed-1 = "<leader>f";
          group = "Fuzzy Find";
        }
        {
          __unkeyed-1 = "<leader>b";
          group = "Buffer";
        }
        {
          __unkeyed-1 = "<leader>l";
          group = "LSP";
        }
        {
          __unkeyed-1 = "<leader>d";
          group = "Diagnostics";
        }
        {
          __unkeyed-1 = "g";
          group = "Goto/LSP";
        }
      ];
    };
  };
}
