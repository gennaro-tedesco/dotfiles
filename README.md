<h1 align="center">
  <br>
  <img src="logo.png" width="400">
  <br>
  dotfiles
  <br>
</h1>

<h2 align="center">
  <a href="https://github.com/gennaro-tedesco/dotfiles/releases">
    <img alt="releases" src="https://img.shields.io/github/release/gennaro-tedesco/dotfiles"/>
  </a>
</h2>

<h4 align="center">My personal dotfiles: no more, no less</h4>
<h3 align="center">
  <a href="#Requirements">Requirements</a> •
  <a href="#Installation">Installation</a> •
  <a href="#Screenshots">Screenshots</a>
</h3>

# Requirements

I am making use of a certain number of system programs that you can find in [`REQUIREMENTS.md`](https://github.com/gennaro-tedesco/dotfiles/blob/master/REQUIREMENTS.md); some of them are necessary as they are included in `zsh` functions as well as `neovim` plugins and `navi` commands, whereas some others are optional.

# Installation

Clone the repository

```
git clone git@github.com:gennaro-tedesco/dotfiles.git
cd dotfiles
```

Use the [`Makefile`](https://github.com/gennaro-tedesco/dotfiles/blob/master/Makefile) to install the programs configurations you want:

```
# to install nvim configurations
make install-nvim

# to install zsh configurations
make install-zsh

# to install navi cheatsheets
make install-navi
```

and so forth.

# Screenshots

<details>
  <summary>Show look</summary>

<img width="1321" src="https://user-images.githubusercontent.com/15387611/116796202-10b83700-aadb-11eb-887a-510fc540d142.png">
<img width="1321" src="https://user-images.githubusercontent.com/15387611/149603156-a0dddbfb-62d3-40ef-afc8-532be85fc5bc.png">
</details>
