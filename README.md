# Personal Neovim Configuration

Personal Neovim configuration.

## Install on Linux

```sh
git clone https://codeberg.org/svin/svin.nvim.git ~/.config/nvim
```

## Install on Windows

```powershell
git clone https://codeberg.org/svin/svin.nvim.git "$env:LOCALAPPDATA\\nvim"
```

## Nix

Standalone:

```sh
nix run git+https://codeberg.org/svin/svin.nvim
```

Home Manager — add the flake as an input and import `inputs.svin-nvim.homeModules.default`.


