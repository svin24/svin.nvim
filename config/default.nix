{
  # Compose configuration from focused modules.
  imports = [
    ./options.nix
    ./plugins.nix
    ./theme.nix
    ./mini.nix
    ./keymaps.nix
    ./treesitter.nix
    ./lsp.nix
  ];

  clipboard.providers.wl-copy.enable = true;
  dependencies.tree-sitter.enable = true;
}
