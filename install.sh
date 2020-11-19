#!/bin/bash 
VIMCONFIG_DIR=~/.vim/
GLOWCONFIG_DIR=~/.config/glowconfig/
RANGERCONFIG_DIR=~/.config/ranger/

echo "------------"
echo "installation"
echo "------------"

echo "copying zsh config file"
cp -f zshrc ~/.zshrc 

echo "copying vim config file"
cp -f vimrc ~/.vimrc

echo "copying ~/.vim configurations and options"
mkdir -p $VIMCONFIG_DIR/ftplugin
mkdir -p $VIMCONFIG_DIR/plugin
cp -r vim/ftplugin/. $VIMCONFIG_DIR/ftplugin
cp -r vim/plugin/. $VIMCONFIG_DIR/plugin

echo "installing Vim Plugins"
[ -f "$VIMCONFIG_DIR/autoload/plug.vim" ] || \
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim -cPlugInstall -cqa

echo "copying ranger config file"
cp -f rc.conf $RANGERCONFIG_DIR 

echo "copying visidata config file"
cp -f visidatarc ~/.visidatarc

#echo "copying git config file"
#cp -f gitconfig ~/.gitconfig

echo "copying glow config file"
mkdir -p $GLOWCONFIG_DIR
cp -f customglow.json $GLOWCONFIG_DIR

