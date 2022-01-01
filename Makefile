NEOVIMCONFIG_DIR=${HOME}/.config/nvim
VIFILEMANAGERCONFIG_DIR=${HOME}/.config/vifm
GLOWCONFIG_DIR=${HOME}/.config/glowconfig
NAVICONFIG_DIR=${HOME}/.config/navi

.PHONY: help
help:
	@printf "%s\n" "Targets:"
	@grep -E '^[a-zA-Z0-9_-]+:.*' $(MAKEFILE_LIST) | grep -v 'help:' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  make %-15s\033[0m %s\n", $$1, $$2}'

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
	cp -f zsh/zshfun ${HOME}/.zshfun
	cp -f zsh/p10k.zsh ${HOME}/.p10k.zsh
	exec zsh

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
	cp -f git/config.yml ${HOME}/.config/gh

.PHONY: install-glow
install-glow:
	mkdir -p ${GLOWCONFIG_DIR}
	cp -f glow/customglow.json ${GLOWCONFIG_DIR}

.PHONY: install-navi
install-navi:
	mkdir -p ${NAVICONFIG_DIR}
	cp -r navi/. ${NAVICONFIG_DIR}
