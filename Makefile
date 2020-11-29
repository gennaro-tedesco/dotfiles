VIMCONFIG_DIR=${HOME}/.vim
RANGERCONFIG_DIR=${HOME}/.config/ranger
GLOWCONFIG_DIR=${HOME}/.config/glowconfig

install-all: install-vim install-zsh install-ranger install-glow install-visidata install-git

install-vim:
	cp -f vim/vimrc ${HOME}/.vimrc
	mkdir -p ${VIMCONFIG_DIR}/ftplugin
	mkdir -p ${VIMCONFIG_DIR}/plugin
	cp -r vim/ftplugin/. ${VIMCONFIG_DIR}/ftplugin
	cp -r vim/plugin/. ${VIMCONFIG_DIR}/plugin
	#[ -f "${HOME}/.vim/autoload/plug.vim" ] || curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	#vim -cPlugClean -cPlugInstall -cPlugUpdate -cqa

install-zsh:
	cp -f zsh/zshrc ${HOME}/.zshrc
	cp -f zsh/p10k.zsh ${HOME}/.p10k.zsh 

install-ranger:
	cp -f ranger/rc.conf ${RANGERCONFIG_DIR}
	cp -f ranger/scope.sh ${RANGERCONFIG_DIR}

install-visidata:
	cp -f visidata/visidatarc ${HOME}/.visidatarc

install-git:
	cp -f git/gitconfig ${HOME}/.gitconfig

install-glow:
	mkdir -p ${GLOWCONFIG_DIR}
	cp -f glow/customglow.json ${GLOWCONFIG_DIR}

