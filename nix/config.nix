{ pkgs, ... }:
{
  opts = {
    number = true;
    ignorecase = true;
    smartcase = true;
    hlsearch = false;
    tabstop = 2;
    shiftwidth = 2;
    showmode = false;
    termguicolors = true;
    updatetime = 250;
    timeoutlen = 300;
    signcolumn = "yes";
    undofile = true;
    mouse = "a";
    clipboard = "unnamedplus";

    langmap = "ΑA,ΒB,ΨC,ΔD,ΕE,ΦF,ΓG,ΗH,ΙI,ΞJ,ΚK,ΛL,ΜM,ΝN,ΟO,ΠP,QQ,ΡR,ΣS,ΤT,ΘU,ΩV,WW,ΧX,ΥY,ΖZ,αa,βb,ψc,δd,εe,φf,γg,ηh,ιi,ξj,κk,λl,μm,νn,οo,πp,qq,ρr,σs,τt,θu,ωv,ςw,χx,υy,ζz";
    langnoremap = true;
    guifont = "JetBrainsMono Nerd Font:h10";
  };

  globals = {
    mapleader = " ";

    neovide_cursor_animation_length = 0.0;
    neovide_cursor_short_animation_length = 0.0;
    neovide_cursor_trail_size = 0.0;
    neovide_cursor_vfx_mode = "";
    neovide_position_animation_length = 0.0;
    neovide_scroll_animation_length = 0.0;
    neovide_scroll_animation_far_lines = 0;
    neovide_cursor_animate_in_insert_mode = false;
    neovide_cursor_animate_command_line = false;
    neovide_cursor_smooth_blink = false;
  };

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
      key = "<leader>bc";
      action = "<cmd>lua pcall(MiniBufremove.delete)<cr>";
      options.desc = "Close buffer";
    }
    {
      mode = "n";
      key = "<leader>e";
      action = "<cmd>Explore<cr>";
      options.desc = "File explorer";
    }
    {
      mode = "n";
      key = "<leader>?";
      action.__raw = "require('telescope.builtin').oldfiles";
      options.desc = "Search file history";
    }
    {
      mode = "n";
      key = "<leader><space>";
      action.__raw = "require('telescope.builtin').buffers";
      options.desc = "Search open files";
    }
    {
      mode = "n";
      key = "<leader>sf";
      action.__raw = "require('telescope.builtin').find_files";
      options.desc = "Search all files";
    }
    {
      mode = "n";
      key = "<leader>sg";
      action.__raw = "require('telescope.builtin').live_grep";
      options.desc = "Search in project";
    }
    {
      mode = "n";
      key = "<leader>sd";
      action.__raw = "require('telescope.builtin').diagnostics";
      options.desc = "Search diagnostics";
    }
    {
      mode = "n";
      key = "<leader>ss";
      action.__raw = "require('telescope.builtin').current_buffer_fuzzy_find";
      options.desc = "Buffer local search";
    }
    {
      mode = "n";
      key = "[d";
      action.__raw = "function() vim.diagnostic.jump({ count = -1, float = true }) end";
      options.desc = "Prev diagnostic";
    }
    {
      mode = "n";
      key = "]d";
      action.__raw = "function() vim.diagnostic.jump({ count = 1, float = true }) end";
      options.desc = "Next diagnostic";
    }
    {
      mode = "n";
      key = "<leader>ld";
      action.__raw = "vim.diagnostic.open_float";
      options.desc = "Line diagnostics";
    }
  ];

  plugins = {
    which-key = {
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
      };
    };

    mini = {
      enable = true;
      modules = {
        ai = {
          n_lines = 500;
        };
        comment = { };
        surround = { };
        bufremove = { };
        snippets = { };
      };
    };

    web-devicons.enable = true;

    telescope = {
      enable = true;
      settings = { };
    };

    blink-cmp = {
      enable = true;
      settings = {
        keymap = {
          preset = "default";
          "<CR>" = [
            "accept"
            "fallback"
          ];
        };
        sources = {
          default = [
            "lsp"
            "path"
            "snippets"
            "buffer"
          ];
          providers = {
            path = {
              opts = {
                get_cwd.__raw = "function(_) return vim.fn.getcwd() end";
              };
            };
          };
        };
        completion = {
          list = {
            selection = {
              preselect = true;
              auto_insert = false;
            };
          };
          menu = {
            draw = {
              columns = [
                [
                  "label"
                  "label_description"
                ]
                [ "kind" ]
              ];
            };
          };
        };
      };
    };

    treesitter = {
      enable = true;
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        lua
        vim
        vimdoc
        c
        query
      ];
      settings.highlight.enable = true;
    };

    lsp = {
      enable = true;
      servers = {
        lua_ls = {
          enable = true;
          settings = {
            Lua = {
              runtime = {
                version = "LuaJIT";
                path = [
                  "lua/?.lua"
                  "lua/?/init.lua"
                ];
              };
              workspace = {
                checkThirdParty = false;
              };
            };
          };
        };

        clangd = {
          enable = true;
          extraOptions = {
            cmd = [
              "clangd"
              "--background-index"
              "--clang-tidy"
              "--completion-style=bundled"
              "--cross-file-rename"
              "--header-insertion=iwyu"
            ];
          };
        };

        nil_ls = {
          enable = true;
          settings = {
            nil = {
              formatting = {
                command = [ "nixfmt" ];
              };
            };
          };
        };

        ols = {
          enable = true;
        };
      };
    };
  };

  autoCmd = [
    {
      event = "LspAttach";
      desc = "LSP actions";
      callback.__raw = ''
        function(event)
          local opts = { buffer = event.buf }

          vim.keymap.set('n', 'grr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
          vim.keymap.set('n', 'gri', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
          vim.keymap.set('n', 'grt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
          vim.keymap.set('n', 'grn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
          vim.keymap.set('n', 'gra', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
          vim.keymap.set('n', 'gO', '<cmd>lua vim.lsp.buf.document_symbol()<cr>', opts)
          vim.keymap.set({ 'i', 's' }, '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)

          vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
          vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
          vim.keymap.set('n', 'grd', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
          vim.keymap.set({ 'n', 'x' }, 'gq', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
          vim.keymap.set('n', '<leader>lf', function()
            vim.lsp.buf.format({ async = true })
          end, vim.tbl_extend('keep', { desc = 'Format buffer' }, opts))
          vim.keymap.set('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<cr>',
            vim.tbl_extend('keep', { desc = 'Code action' }, opts))
          vim.keymap.set('n', '<leader>lr', '<cmd>lua vim.lsp.buf.rename()<cr>',
            vim.tbl_extend('keep', { desc = 'Rename symbol' }, opts))
        end
      '';
    }
    {
      event = "BufWritePre";
      desc = "Auto-format on save";
      callback.__raw = ''
        function(event)
          if vim.g.vscode then return end
          local clients = vim.lsp.get_clients({ bufnr = event.buf })
          if #clients > 0 then
            vim.lsp.buf.format({ async = false, bufnr = event.buf })
          end
        end
      '';
    }
  ];

  extraConfigLua = ''
    vim.cmd.colorscheme('habamax')

    require('which-key').add({
      { '<leader>f', group = 'Fuzzy Find' },
      { '<leader>b', group = 'Buffer' },
      { '<leader>l', group = 'LSP' },
      { '<leader>d', group = 'Diagnostics' },
      { 'g', group = 'Goto/LSP' },
    })
  '';

  extraPackages = with pkgs; [
    lua-language-server
    clang-tools
    nil
    nixfmt
    tree-sitter
    ols
  ];
}
