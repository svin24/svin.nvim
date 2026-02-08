{ pkgs, ... }:
{
  plugins.treesitter = {
    enable = true;
    highlight.enable = true;

    grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
      lua
      vim
      vimdoc
      c
      query
    ];
  };
}
