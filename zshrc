if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# themes and prompt
ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_MODE="awesome-patched"

# list of plugins to load
plugins=(
		auto-ls
		fzf-tab
		zsh-interactive-cd
		zsh-autosuggestions
		zsh-syntax-highlighting
		z
		)

# Path to your oh-my-zsh installation.
export ZSH="/Users/gennarotedesco/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

# exporting environment variables
export LANG=en_US.UTF-8
export LC_CTYPE="en_US.UTF-8"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export FZF_DEFAULT_OPTS='--reverse --border -e'

# aliases
alias zshconfig="vim ~/.zshrc"
alias vimconfig="vim ~/.vimrc"
alias ls="exa --long --header --git --sort=extension"
alias tree="exa --tree --level=2"
alias cat="preview_files"
alias prod_shell="PIPENV_DOTENV_LOCATION=prod.env pipenv shell"
alias dev_shell="PIPENV_DOTENV_LOCATION=dev.env pipenv shell"
alias p="pipes.sh"
alias todo="vim ~/.todo"
alias cal="vim -c Calendar"
alias zenith="zenith -d 0 -n 0"
alias du="dust"

## ----------------
## custom functions
## ----------------

# fzf options and functions to fuzzy open with vim
ff() (
  IFS=$'\n' files=($(fzf --reverse --border  --preview 'bat --style=numbers --color=always {} | head -500' --query="$1" --multi --select-1 --exit-0))
  [[ -n "$files" ]] && ${EDITOR:-vim} "${files[@]}"
)

# fzf browse directories and cd into them
fd() {
  local dir
  dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
}

# fzf checkout git branches
fb() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}


# preview files
preview_files () {
	if [[ $1 == *.md ]]; then
		glow -s ~/.config/glowconfig/customglow.json -p $1
	elif [[ $1 == *.json ]]; then
	   	jq '.' -C $1 | less
	else
		bat --theme='Solarized (dark)' $1
	fi
}


unalias z 2> /dev/null
z() {
  [ $# -gt 0 ] && _z "$*" && return
  cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
}

## -----------------------
## additional source files  
## -----------------------

# sourcing fzf keybindings
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# source plugins 
source <(navi widget zsh)
