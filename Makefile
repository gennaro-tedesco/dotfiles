VIMCONFIG_DIR=${HOME}/.vim
NEOVIMCONFIG_DIR=${HOME}/.config/nvim
VIFILEMANAGERCONFIG_DIR=${HOME}/.config/vifm
GLOWCONFIG_DIR=${HOME}/.config/glowconfig

.PHONY: install-vim
install-vim:
	mkdir -p ${VIMCONFIG_DIR}
	cp -r vim/. ${VIMCONFIG_DIR}
ifdef plug
	vim -cPlugClean -cPlugInstall -cPlugUpdate -cqa
endif

.PHONY: install-nvim
install-nvim:
	mkdir -p ${NEOVIMCONFIG_DIR}
	cp -r nvim/. ${NEOVIMCONFIG_DIR}
ifdef plug
	nvim -cPlugClean -cPlugInstall -cPlugUpdate -cUpdateRemotePlugins -cqa
endif
	
.PHONY: install-zsh
install-zsh:
	cp -f zsh/zshrc ${HOME}/.zshrc
	cp -f zsh/p10k.zsh ${HOME}/.p10k.zsh

.PHONY: install-vifm
install-vifm:
	cp -r vifm/colors/. ${VIFILEMANAGERCONFIG_DIR}/colors
	cp -f vifm/vifmrc ${VIFILEMANAGERCONFIG_DIR}

.PHONY: install-visidata
install-visidata:
	cp -f visidata/visidatarc ${HOME}/.visidatarc

.PHONY: install-git
install-git:
	cp -f git/gitconfig ${HOME}/.gitconfig

.PHONY: install-glow
install-glow:
	mkdir -p ${GLOWCONFIG_DIR}
	cp -f glow/customglow.json ${GLOWCONFIG_DIR}

