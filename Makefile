VIMCONFIG_DIR=${HOME}/.vim
VIFILEMANAGERCONFIG_DIR=${HOME}/.config/vifm
GLOWCONFIG_DIR=${HOME}/.config/glowconfig

.PHONY: install-all
install-all: install-vim install-zsh install-vifm install-ranger install-glow install-visidata install-git

install-vim:
	cp -f vim/vimrc ${HOME}/.vimrc
	mkdir -p ${VIMCONFIG_DIR}/after
	mkdir -p ${VIMCONFIG_DIR}/autoload
	mkdir -p ${VIMCONFIG_DIR}/plugin
	cp -r vim/after/. ${VIMCONFIG_DIR}/after
	cp -r vim/autoload/. ${VIMCONFIG_DIR}/autoload
	cp -r vim/plugin/. ${VIMCONFIG_DIR}/plugin
# 	[ -f "${HOME}/.vim/autoload/plug.vim" ] || curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# 	vim -cPlugClean -cPlugInstall -cPlugUpdate -cqa

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

