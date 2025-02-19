NEOVIMCONFIG_DIR=${HOME}/.config/nvim
VIFILEMANAGERCONFIG_DIR=${HOME}/.config/vifm
GLOWCONFIG_DIR=${HOME}/.config/glowconfig
NAVICONFIG_DIR=${HOME}/.config/navi
MACCHINACONFIG_DIR=${HOME}/.config/macchina
BATCONFIG_DIR=${HOME}/.config/bat
WEZTERMCONFIG_DIR=${HOME}/.config/wezterm

.PHONY: *
help:
	@printf "%s\n" "Targets:"
	@grep -E '^[a-zA-Z0-9_-]+:.*' Makefile \
	| grep -v 'help:' \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-15s\033[0m %s\n", $$1, $$2}' \
	| sed 's/:$///g'

deps:
	brew bundle install
	zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1

nvim:
	rm -rf ${NEOVIMCONFIG_DIR}
	mkdir -p ${NEOVIMCONFIG_DIR}
	cp -r nvim/. ${NEOVIMCONFIG_DIR}
	nvim --headless "+Lazy! restore" +qa

zsh:
	cp -f zsh/zshrc ${HOME}/.zshrc
	cp -f zsh/zshfun ${HOME}/.zshfun
	cp -f zsh/p10k.zsh ${HOME}/.p10k.zsh
	cp -f zsh/lesskey ${HOME}/.lesskey
	rm -rf ${BATCONFIG_DIR}
	mkdir ${BATCONFIG_DIR}
	cp -f zsh/batconfig ${BATCONFIG_DIR}/config
	exec zsh

wezterm:
	mkdir -p ${WEZTERMCONFIG_DIR}
	cp -r wezterm/. ${WEZTERMCONFIG_DIR}

vifm:
	rm -rf ${VIFILEMANAGERCONFIG_DIR}
	mkdir ${VIFILEMANAGERCONFIG_DIR}
	cp -r vifm/colors/. ${VIFILEMANAGERCONFIG_DIR}/colors
	cp -r vifm/. ${VIFILEMANAGERCONFIG_DIR}

visidata:
	cp -f visidata/visidatarc ${HOME}/.visidatarc

git:
	cp -f git/gitconfig ${HOME}/.gitconfig
	cp -f git/config.yml ${HOME}/.config/gh

glow:
	mkdir -p ${GLOWCONFIG_DIR}
	cp -f glow/customglow.json ${GLOWCONFIG_DIR}

navi:
	mkdir -p ${NAVICONFIG_DIR}
	cp -r navi/. ${NAVICONFIG_DIR}

yabai:
	yabai --stop-service
	mkdir -p ${HOME}/.config/yabai
	mkdir -p ${HOME}/.config/skhd
	cp -f yabai/yabairc ${HOME}/.config/yabai/yabairc
	cp -f yabai/skhdrc ${HOME}/.config/skhd/skhdrc
	yabai --start-service
	skhd --start-service

macchina:
	mkdir -p ${MACCHINACONFIG_DIR}
	cp -r macchina/. ${HOME}/.config/macchina
