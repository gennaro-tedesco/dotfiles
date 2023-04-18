<h1 align="center">
  <br>
  <img src="https://user-images.githubusercontent.com/15387611/210538715-2d537b97-8093-4436-8ed4-5f6e76a75459.png" width="300">
  <br>
  evergreen
  <br>
</h1>

## Description

evergreen is a simple but at the same time precise and complete neovim configuration fully written in lua 🌙. It is a continuous work in progress, however the pinned releases are tested and stable. The structure is as follows:

```
├── after
│  ├── ftplugin
│  └── syntax
├── lua
│  ├── plugins
│  ├── filetype.lua
│  ├── utils.lua
│  ├── mappings.lua
│  └── settings.lua
├── lazy-lock.json
├── init.lua
└── README.md
```

| plugin manager 🚀                               | plugins 🔌                                                                                                                  | latest release 🔏                                                        |
| :---------------------------------------------- | :-------------------------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------- |
| [lazy.nvim](https://github.com/folke/lazy.nvim) | [plugins](https://github.com/gennaro-tedesco/dotfiles/blob/51602e9e1dec7d13160baad2586c0ee4e408d4ff/nvim/init.lua#L35-L287) | [0.5.0](https://github.com/gennaro-tedesco/dotfiles/releases/tag/v0.5.0) |

## Installation

Git clone or copy this repository replacing your current `~/.config/nvim`, or simply use the [Makefile](https://github.com/gennaro-tedesco/dotfiles/blob/51602e9e1dec7d13160baad2586c0ee4e408d4ff/Makefile#L11) and `make install-nvim`.
