{
  # Compose configuration from focused modules.
  imports = [
    ./options.nix
    ./plugins.nix
    ./which-key.nix
    ./theme.nix
    ./mini.nix
    ./keymaps.nix
    ./treesitter.nix
    ./lsp.nix
  ];

  clipboard.providers.wl-copy.enable = true;
  
	dependencies = {
    tree-sitter.enable = true;
    gcc.enable = true;
    curl.enable = true;
  };
}
