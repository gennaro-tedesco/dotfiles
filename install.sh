#!/bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install git

brew tap anomalyco/tap
brew tap asmvik/formulae
brew tap homebrew-zathura/zathura

brew install \
	asmvik/formulae/skhd \
	asmvik/formulae/yabai \
	bash-language-server \
	bat \
	coreutils \
	duf \
	eza \
	fd \
	fzf \
	gh \
	git-delta \
	glow \
	gnu-sed \
	go \
	goimports \
	gping \
	gron \
	gum \
	insect \
	jq \
	latexindent \
	lazydocker \
	lazygit \
	lua-language-server \
	luacheck \
	macchina \
	marksman \
	mdformat \
	navi \
	ncdu \
	node \
	opencode-v2 \
	prettier \
	ripgrep \
	rtk \
	scc \
	shellcheck \
	shfmt \
	stylua \
	taplo \
	texlab \
	uv \
	vivid \
	zathura \
	zathura-pdf-poppler \
	zellij \
	zenith \
	zoxide

brew install --cask \
	docker \
	font-fira-code-nerd-font \
	font-museo \
	wezterm

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
rustup default stable
rustup component add rust-analyzer rustfmt

cargo install bob-nvim
bob install nightly
bob use nightly

cargo install tree-sitter-cli
cargo install xan
cargo install yazi-fm@25.5.31
cargo install yazi-cli@25.5.31

uv tool install basedpyright
uv tool install black
uv tool install isort
uv tool install mypy
uv tool install ruff
uv tool install visidata

npm install --global \
	vscode-langservers-extracted \
	yaml-language-server

go install golang.org/x/tools/gopls@latest

curl -fsSL https://claude.ai/install.sh | bash

zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
