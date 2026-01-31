# tabman.nvim

This plugin provides a way to navigate between tabs and windows they contain.

[![GitHub License](https://img.shields.io/github/license/wsdjeg/tabman.nvim)](LICENSE)
[![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/wsdjeg/tabman.nvim)](https://github.com/wsdjeg/tabman.nvim/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/wsdjeg/tabman.nvim)](https://github.com/wsdjeg/tabman.nvim/commits/master/)
[![GitHub Release](https://img.shields.io/github/v/release/wsdjeg/tabman.nvim)](https://github.com/wsdjeg/tabman.nvim/releases)
[![luarocks](https://img.shields.io/luarocks/v/wsdjeg/tabman.nvim)](https://luarocks.org/modules/wsdjeg/tabman.nvim)

<!-- vim-markdown-toc GFM -->

- [Installation](#installation)
- [Usage](#usage)
- [Picker tabman](#picker-tabman)
- [Credits](#credits)
- [Self-Promotion](#self-promotion)
- [License](#license)

<!-- vim-markdown-toc -->

## Installation

Using nvim-plug:

```lua
require("plug").add({ {
	"wsdjeg/tabman.nvim",
} })
```

## Usage

This plugin provides a `:Tabman` command, It will open a tab manager windows.

In the tab manager windows, the following key bindings can be used:

| Key binding | Description              |
| ----------- | ------------------------ |
| `q`         | close tab manager        |
| `o`         | toggle expand tabpage    |
| `x`         | delete tabpage           |
| `<Enter>`   | jump to selected windows |

## Picker tabman

tabman.nvim also provides a `tabman` source for picker.nvim. which can be opened via `:Picker tabman`.

key bindings for picker mru extension:

| Key Binding | Description             |
| ----------- | ----------------------- |
| `<Enter>`   | switch to select window |

```lua
vim.api.nvim_set_keymap('n', '<leader>t', ':Picker tabman<CR>', { noremap = true, silent = true })
```

## Credits

- [tabmanager](https://github.com/wsdjeg/SpaceVim/blob/eed9d8f14951d9802665aa3429e449b71bb15a3a/autoload/SpaceVim/plugins/tabmanager.vim)
- [tabman.vim](https://github.com/kien/tabman.vim)

## Self-Promotion

Like this plugin? Star the repository on
GitHub.

Love this plugin? Follow [me](https://wsdjeg.net/) on
[GitHub](https://github.com/wsdjeg).

## License

This project is licensed under the GPL-3.0 License.
