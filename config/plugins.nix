{ pkgs, inputs, ... }:
{
  extraPackages = with pkgs; [
    nixpkgs-fmt
  ];
}
