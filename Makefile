VIMCONFIG_DIR=${HOME}/.vim
NEOVIMCONFIG_DIR=${HOME}/.config/nvim
VIFILEMANAGERCONFIG_DIR=${HOME}/.config/vifm
GLOWCONFIG_DIR=${HOME}/.config/glowconfig

.PHONY: install-all
install-all: install-vim install-nvim install-zsh install-vifm install-ranger install-glow install-visidata install-git

install-vim:
	mkdir -p ${VIMCONFIG_DIR}
	cp -r vim/. ${VIMCONFIG_DIR}
#	vim -cPlugClean -cPlugInstall -cPlugUpdate -cqa

install-nvim:
	mkdir -p ${NEOVIMCONFIG_DIR}
	cp -r nvim/. ${NEOVIMCONFIG_DIR}
#	nvim -cPlugClean -cPlugInstall -cPlugUpdate -cUpdateRemotePlugins -cqa

install-zsh:
	cp -f zsh/zshrc ${HOME}/.zshrc
	cp -f zsh/p10k.zsh ${HOME}/.p10k.zsh

install-vifm:
	cp -r vifm/colors/. ${VIFILEMANAGERCONFIG_DIR}/colors
	cp -f vifm/vifmrc ${VIFILEMANAGERCONFIG_DIR}

install-visidata:
	cp -f visidata/visidatarc ${HOME}/.visidatarc

install-git:
	cp -f git/gitconfig ${HOME}/.gitconfig

install-glow:
	mkdir -p ${GLOWCONFIG_DIR}
	cp -f glow/customglow.json ${GLOWCONFIG_DIR}

