<img src="logo.png" width="400">

# dotfiles
My personal dotfiles: no more, no less

# Requirements
I am making use of the following system programs:

- vifm: https://vifm.info/
- bat: https://github.com/sharkdp/bat
- exa: https://the.exa.website/
- fzf: https://github.com/junegunn/fzf
- visidata: https://www.visidata.org/install/
- jq: https://stedolan.github.io/jq/
- glow: https://github.com/charmbracelet/glow
- zenith: https://github.com/bvaisvil/zenith
- dust: https://github.com/bootandy/dust
- navi: https://github.com/denisidoro/navi
- ripgrep: https://github.com/BurntSushi/ripgrep
- delta: https://github.com/dandavison/delta

Most of them are necessary as they are included in `zsh` functions as well as `vim` plugins.

# Installation
Clone the repository
```
git clone git@github.com:gennaro-tedesco/dotfiles.git
cd dotfiles
```
Use the [`Makefile`](https://github.com/gennaro-tedesco/dotfiles/blob/master/Makefile) to install the programs you want:
```
# to copy the vim configurations
make install-vim

# to copy zsh configurations
make install-zsh
```
and so forth. To install all programs run `make install-all`.

