{ inputs }:
{ pkgs, ... }:
{
  environment.systemPackages = [
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  environment.shellAliases = {
    vim = "nvim";
  };
}
