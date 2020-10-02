#!/bin/bash 

echo "------------"
echo "installation"
echo "------------"

echo "copying zsh config file.."
cp -f zshrc ~/.zshrc 

echo "copying vim config file..."
cp -f vimrc ~/.vimrc

echo "copying ranger config file..."
cp -f rc.conf ~/.config/ranger/rc.conf 

echo "copying visidata config file ..."
cp -f visidatarc ~/.visidatarc

echo "copying git config file ..."
cp -f gitconfig ~/.gitconfig

echo "copying glow config file..."
mkdir ~/.config/glowconfig/ && cp -f customglow.json ~/.config/glowconfig/customglow.json
