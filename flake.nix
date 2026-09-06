{
  description = "svin.nvim — personal Neovim config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixvim.url = "github:nix-community/nixvim/nixos-26.05";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixvim,
    }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      homeModules.default = {
        imports = [ nixvim.homeModules.nixvim ];
        programs.nixvim = {
          enable = true;
          vimAlias = true;
          defaultEditor = true;
          imports = [ ./nix/config.nix ];
        };
      };
      homeManagerModules.default = self.homeModules.default;

      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = nixvim.legacyPackages.${system}.makeNixvimWithModule {
            inherit pkgs;
            module = ./nix/config.nix;
          };
        }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);
    };
}
