.PHONY: *
help:
	@printf "%s\n" "Targets:"
	@grep -E '^[a-zA-Z0-9_-]+:.*' Makefile \
	| grep -v 'help:' \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m  %-15s\033[0m %s\n", $$1, $$2}' \
	| sed 's/:$///g'

deps:
	zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1

nvim:
	rm -rf ${XDG_CONFIG_HOME}/nvim
	mkdir -p ${XDG_CONFIG_HOME}/nvim
	cp -r nvim/. ${XDG_CONFIG_HOME}/nvim
	nvim --headless "+Lazy! restore" +qa

zsh:
	cp -f zsh/zshrc ${HOME}/.zshrc
	cp -f zsh/zshfun ${HOME}/.zshfun
	cp -f zsh/p10k.zsh ${HOME}/.p10k.zsh
	cp -f zsh/lesskey ${HOME}/.lesskey
	exec zsh

bat:
	rm -rf ${XDG_CONFIG_HOME}/bat
	mkdir -p ${XDG_CONFIG_HOME}/bat
	cp -r bat/. ${XDG_CONFIG_HOME}/bat
	bat cache --build

wezterm:
	mkdir -p ${XDG_CONFIG_HOME}/wezterm
	cp -r wezterm/. ${XDG_CONFIG_HOME}/wezterm

yazi:
	rm -rf ${XDG_CONFIG_HOME}/yazi
	mkdir -p ${XDG_CONFIG_HOME}/yazi
	cp -r yazi/. ${XDG_CONFIG_HOME}/yazi
	ya pkg install

visidata:
	cp -f visidata/visidatarc ${HOME}/.visidatarc

git:
	cp -f git/gitconfig ${HOME}/.gitconfig
	mkdir -p ${XDG_CONFIG_HOME}/gh
	cp -f git/config.yml ${XDG_CONFIG_HOME}/gh/config.yml

glow:
	mkdir -p ${XDG_CONFIG_HOME}/glowconfig
	cp -f glow/customglow.json ${XDG_CONFIG_HOME}/glowconfig

navi:
	rm -rf ${XDG_CONFIG_HOME}/navi
	mkdir -p ${XDG_CONFIG_HOME}/navi
	cp -r navi/. ${XDG_CONFIG_HOME}/navi

yabai:
	yabai --stop-service
	mkdir -p ${XDG_CONFIG_HOME}/yabai
	mkdir -p ${XDG_CONFIG_HOME}/skhd
	cp -f yabai/yabairc ${XDG_CONFIG_HOME}/yabai/yabairc
	cp -f yabai/skhdrc ${XDG_CONFIG_HOME}/skhd/skhdrc
	yabai --start-service
	skhd --start-service

macchina:
	mkdir -p ${XDG_CONFIG_HOME}/macchina
	cp -r macchina/. ${XDG_CONFIG_HOME}/macchina
