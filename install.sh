#!/bin/bash 
VIMCONFIG=~/.vim
GLOWCONFIG_DIR=~/.config/glowconfig/

echo "------------"
echo "installation"
echo "------------"

echo "copying zsh config file"
cp -f zshrc ~/.zshrc 

echo "copying vim config file"
cp -f vimrc ~/.vimrc

echo "copying ~/.vim configurations and options"
mkdir -p $VIMCONFIG/ftplugin
mkdir -p $VIMCONFIG/plugin
cp -r vim/ftplugin/. $VIMCONFIG/ftplugin
cp -r vim/plugin/. $VIMCONFIG/plugin

## echo "Installing Vim Plugins"
## curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
## vim -cPlugInstall -cqa

echo "copying ranger config file"
cp -f rc.conf ~/.config/ranger/rc.conf 

echo "copying visidata config file"
cp -f visidatarc ~/.visidatarc

echo "copying git config file"
cp -f gitconfig ~/.gitconfig

echo "copying glow config file"
mkdir -p $GLOWCONFIG_DIR
cp -f customglow.json ${GLOWCONFIG_DIR}
