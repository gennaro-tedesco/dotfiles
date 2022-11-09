NEOVIMCONFIG_DIR=${HOME}/.config/nvim
VIFILEMANAGERCONFIG_DIR=${HOME}/.config/vifm
GLOWCONFIG_DIR=${HOME}/.config/glowconfig
NAVICONFIG_DIR=${HOME}/.config/navi

.PHONY: *
help:
	@printf "%s\n" "Targets:"
	@grep -E '^[a-zA-Z0-9_-]+:.*' $(MAKEFILE_LIST) | grep -v 'help:' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  make %-15s\033[0m %s\n", $$1, $$2}'

install-nvim:
	mkdir -p ${NEOVIMCONFIG_DIR}
	cp -r nvim/. ${NEOVIMCONFIG_DIR}
ifdef plug
	nvim -cPlugClean -cPlugInstall -cPlugUpdate -cqa
endif

install-zsh:
	cp -f zsh/zshrc ${HOME}/.zshrc
	cp -f zsh/zshfun ${HOME}/.zshfun
	cp -f zsh/p10k.zsh ${HOME}/.p10k.zsh
	exec zsh

install-vifm:
	cp -r vifm/colors/. ${VIFILEMANAGERCONFIG_DIR}/colors
	cp -r vifm/. ${VIFILEMANAGERCONFIG_DIR}

install-visidata:
	cp -f visidata/visidatarc ${HOME}/.visidatarc

install-git:
	cp -f git/gitconfig ${HOME}/.gitconfig
	cp -f git/config.yml ${HOME}/.config/gh

install-glow:
	mkdir -p ${GLOWCONFIG_DIR}
	cp -f glow/customglow.json ${GLOWCONFIG_DIR}

install-navi:
	mkdir -p ${NAVICONFIG_DIR}
	cp -r navi/. ${NAVICONFIG_DIR}
