fpath=(/usr/share/zsh/site-functions/ $fpath)

# colors
eval `dircolors $HOME/.zsh/colors`

autoload -U zutil
autoload -U compinit
autoload -U complist
autoload -U insert-unicode-char
autoload -U select-word-style
select-word-style bash

zle -N insert-unicode-char

setopt EMACS

bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward
bindkey '^K' kill-whole-line
bindkey "\e[H" beginning-of-line        # Home (xorg)
bindkey "\e[1~" beginning-of-line       # Home (console)
bindkey "\e[4~" end-of-line             # End (console)
bindkey "\e[F" end-of-line              # End (xorg)
bindkey "\e[2~" overwrite-mode          # Ins
bindkey "\e[3~" delete-char             # Delete

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

bindkey "^U" insert-unicode-char

# Activation
compinit

# Resource files
for rcfile in ${HOME}/.zsh/rc/*.rc; do
	source ${rcfile}
done

if [[ -r "${HOME}/.zshrc.local" ]]; then
    source "${HOME}/.zshrc.local"
fi
