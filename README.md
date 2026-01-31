# tabman.nvim

This plugin provides a way to navigate between tabs and windows they contain. It is inspired from [tabmanager](https://github.com//wsdjeg/SpaceVim/blob/eed9d8f14951d9802665aa3429e449b71bb15a3a/autoload/SpaceVim/plugins/tabmanager.vim) and [tabman.vim](https://github.com/kien/tabman.vim).

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

| Key binding | Description           |
| ----------- | --------------------- |
| q           | close tab manager     |
| o           | toggle expand tabpage |
| x           | delete tabpage        |

## Picker tabman

tabman.nvim also provides a `tabman` source for picker.nvim. which can be opened via `:Picker tabman`.

key bindings for picker mru extension:

| Key Binding | Description             |
| ----------- | ----------------------- |
| `<Enter>`   | switch to select window |

```lua
vim.api.nvim_set_keymap('n', '<leader>t', ':Picker tabman<CR>', { noremap = true, silent = true })
```
