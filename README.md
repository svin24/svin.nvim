# svin.nvim

## Introduction

personal neovim config based on kickstart.nvim

### Install External Dependencies

External Requirements:
- Basic utils: `git`, `make`, `unzip`, C Compiler (`gcc`)
- [ripgrep](https://github.com/BurntSushi/ripgrep#installation)
- use checkhealth to find the rest idk


| OS | PATH |
| :- | :--- |
| Linux, MacOS | `$XDG_CONFIG_HOME/nvim`, `~/.config/nvim` |
| Windows (cmd)| `%userprofile%\AppData\Local\nvim\` |
| Windows (powershell)| `$env:USERPROFILE\AppData\Local\nvim\` |

### Install Kickstart

Clone svin.nvim:

<details><summary> Linux and Mac </summary>

```sh
git clone https://github.com/svin24/svin.nvim.git "/nvim"${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
```

</details>

<details><summary> Windows </summary>

If you're using `cmd.exe`:

```
git clone  https://github.com/svin24/svin.nvim.git%userprofile%\AppData\Local\nvim\
```

If you're using `powershell.exe`

```
git clone https://github.com/svin24/svin.nvim.git  $env:USERPROFILE\AppData\Local\nvim\
```

</details>


