{ pkgs, inputs, ... }:
{
  extraPackages = with pkgs; [
    nixpkgs-fmt
  ];

  extraPlugins = with pkgs.vimPlugins; [
    mini-nvim
    which-key-nvim
    nvim-lspconfig
    nvim-web-devicons
    (pkgs.vimUtils.buildVimPlugin {
      pname = "accent.nvim";
      version = inputs.accent-nvim.lastModifiedDate or "dirty";
      src = inputs.accent-nvim;
    })
  ];
}
