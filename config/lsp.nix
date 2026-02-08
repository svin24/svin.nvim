{ pkgs, ... }:
{
  plugins.lspconfig.enable = true;

  lsp.keymaps = [
    {
      mode = "n";
      key = "grr";
      lspBufAction = "references";
    }
    {
      mode = "n";
      key = "gri";
      lspBufAction = "implementation";
    }
    {
      mode = "n";
      key = "grt";
      lspBufAction = "type_definition";
    }
    {
      mode = "n";
      key = "grn";
      lspBufAction = "rename";
    }
    {
      mode = "n";
      key = "gra";
      lspBufAction = "code_action";
    }
    {
      mode = "n";
      key = "gO";
      lspBufAction = "document_symbol";
    }
    {
      mode = [
        "i"
        "s"
      ];
      key = "<C-s>";
      lspBufAction = "signature_help";
    }
    {
      mode = "n";
      key = "K";
      lspBufAction = "hover";
    }
    {
      mode = "n";
      key = "gd";
      lspBufAction = "definition";
    }
    {
      mode = "n";
      key = "grd";
      lspBufAction = "declaration";
    }
    {
      mode = [
        "n"
        "x"
      ];
      key = "gq";
      action.__raw = "function() vim.lsp.buf.format({ async = true }) end";
    }
    {
      mode = "n";
      key = "<leader>lf";
      action.__raw = "function() vim.lsp.buf.format({ async = true }) end";
      options.desc = "Format buffer";
    }
    {
      mode = "n";
      key = "<leader>la";
      lspBufAction = "code_action";
      options.desc = "Code action";
    }
    {
      mode = "n";
      key = "<leader>lr";
      lspBufAction = "rename";
      options.desc = "Rename symbol";
    }
  ];

  lsp.servers = {
    lua_ls = {
      enable = true;
      config = {
        on_init.__raw = ''
          function(client)
            if client.workspace_folders then
              local path = client.workspace_folders[1].name
              if
                path ~= vim.fn.stdpath('config')
                and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
              then
                return
              end
            end

            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = {
                version = 'LuaJIT',
                path = {
                  'lua/?.lua',
                  'lua/?/init.lua',
                },
              },
              workspace = {
                checkThirdParty = false,
                library = {
                  vim.env.VIMRUNTIME,
                },
              },
            })
          end
        '';
        settings = {
          Lua = { };
        };
      };
    };

    clangd = {
      enable = true;
      config.cmd = [
        "clangd"
        "--background-index"
        "--clang-tidy"
        "--completion-style=bundled"
        "--cross-file-rename"
        "--header-insertion=iwyu"
      ];
    };

    nil_ls = {
      enable = true;
      config = {
        settings."nil".formatting.command = [ "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt" ];
      };
    };

    gopls = {
      enable = true;
    };

    intelephense = {
      enable = true;
    };

    rust_analyzer = {
      enable = true;
    };

    denols = {
      enable = true;
    };

    basedpyright = {
      enable = true;
    };
  };
}
