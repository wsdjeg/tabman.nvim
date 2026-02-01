# tabman.nvim

A lightweight tab and window manager for Neovim.

tabman.nvim provides an interactive view to navigate, inspect, and
manage tabpages and the windows they contain.

[![GitHub License](https://img.shields.io/github/license/wsdjeg/tabman.nvim)](LICENSE)
[![GitHub Issues or Pull Requests](https://img.shields.io/github/issues/wsdjeg/tabman.nvim)](https://github.com/wsdjeg/tabman.nvim/issues)
[![GitHub commit activity](https://img.shields.io/github/commit-activity/m/wsdjeg/tabman.nvim)](https://github.com/wsdjeg/tabman.nvim/commits/master/)
[![GitHub Release](https://img.shields.io/github/v/release/wsdjeg/tabman.nvim)](https://github.com/wsdjeg/tabman.nvim/releases)
[![luarocks](https://img.shields.io/luarocks/v/wsdjeg/tabman.nvim)](https://luarocks.org/modules/wsdjeg/tabman.nvim)

![tabman.nvim](https://github.com/user-attachments/assets/5174378e-0386-4e34-b57c-bae206aef9c8)

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

tabman.nvim provides the `:Tabman` command.

It opens an interactive tab manager window that shows all tabpages and
the windows inside each tab.

Key bindings in the tab manager window:

| Key binding | Description                 |
| ----------- | --------------------------- |
| `q`         | Close the tab manager       |
| `o`         | Toggle expand a tabpage     |
| `x`         | Delete the tabpage          |
| `<Enter>`   | Jump to the selected window |

You can also open tabman from Lua, for example with a custom filter:

```lua
require('tabman').open({
  filter = function(win)
    local buf = vim.api.nvim_win_get_buf(win)
    return vim.api.nvim_get_option_value('buflisted', { buf = buf })
  end,
})
```

## Picker tabman

tabman.nvim also provides a `tabman` source for
[picker.nvim](https://github.com/wsdjeg/picker.nvim).

You can open it with:

```
:Picker tabman
```

key bindings for picker mru extension:

| Key Binding | Description             |
| ----------- | ----------------------- |
| `<Enter>`   | switch to select window |

Example mapping:

```lua
vim.api.nvim_set_keymap(
  'n',
  '<leader>t',
  ':Picker tabman<CR>',
  { noremap = true, silent = true }
)
```

## Credits

- [tabmanager](https://github.com/wsdjeg/SpaceVim/blob/eed9d8f14951d9802665aa3429e449b71bb15a3a/autoload/SpaceVim/plugins/tabmanager.vim)
- [tabman.vim](https://github.com/kien/tabman.vim)

## Self-Promotion

If you find this plugin useful, please consider starring it on GitHub.

You can also follow me at:

- Website: [wsdjeg.net](https://wsdjeg.net/)
- GitHub: [@wsdjeg](https://github.com/wsdjeg)

## License

This project is licensed under the GPL-3.0 License.
