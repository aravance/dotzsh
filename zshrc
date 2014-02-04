#!/usr/bin/env zsh

export ZSHD=~/.zsh.d

[ -f $ZSHD/platform ] \
  && . $ZSHD/platform \
  || export PLATFORM=unknown

[ -f $ZSHD/$PLATFORM ] && . $ZSHD/$PLATFORM

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM=$ZSHD

ZSH_THEME=time
#ZSH_THEME=status-prompt
#ZSH_THEME=theunraveler
#ZSH_THEME=random

mac_plugins=(osx macports)

# Plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(
  git
  git-extras
  svn
  repo
  adb
  ls-alias
  ls-color
  ssh-agent
  battery
  spectrum
)
eval plugins+=\(\$${PLATFORM}_plugins\)

[ -f $ZSH/oh-my-zsh.sh ] && . $ZSH/oh-my-zsh.sh

export EDITOR=vim
export VISUAL=$EDITOR

export PATH="~/.bin:$PATH"

# The following lines were added by compinstall

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _oldlist _expand _complete _ignored _match _correct _approximate
zstyle ':completion:*' completions 1
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' file-sort name
zstyle ':completion:*' glob 1
zstyle ':completion:*' group-name ''
zstyle ':completion:*' ignore-parents parent pwd directory
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-prompt %SAt %l : %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' match-original both
zstyle ':completion:*' matcher-list '+' '+' '+r:|[._-]=* r:|=*' '+l:|=* r:|=*'
zstyle ':completion:*' max-errors 10 numeric
zstyle ':completion:*' menu select=long-list select=0 select=0
zstyle ':completion:*' original false
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %l : %p%s
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' substitute 1
zstyle ':completion:*' verbose true

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=$HOME/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob notify
unsetopt beep nomatch
unsetopt hist_verify

# Enable vimode bindings
bindkey -v
# Decrease mode switch delay to 0.1s
export KEYTIMEOUT=1

# End of lines configured by zsh-newuser-install
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*' ignore-parents parent pwd

setopt histignorealldups histnostore incappendhistory correct

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

autoload zkbd
zkbd_file=${ZDOTDIR:-$HOME}/.zkbd/$TERM-$VENDOR-$OSTYPE
[[ ! -f $zkbd_file ]] && zkbd 
[[ -f $zkbd_file ]] && . $zkbd_file

[[ -n ${key[Backspace]} ]] && bindkey "${key[Backspace]}" backward-delete-char
[[ -n ${key[Insert]} ]] && bindkey "${key[Insert]}" overwrite-mode
[[ -n ${key[Home]} ]] && bindkey "${key[Home]}" beginning-of-line
[[ -n ${key[PageUp]} ]] && bindkey "${key[PageUp]}" up-line-or-history
[[ -n ${key[Delete]} ]] && bindkey "${key[Delete]}" delete-char
[[ -n ${key[End]} ]] && bindkey "${key[End]}" end-of-line
[[ -n ${key[PageDown]} ]] && bindkey "${key[PageDown]}" down-line-or-history
[[ -n ${key[Up]} ]] && bindkey "${key[Up]}" up-line-or-search
[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
[[ -n ${key[Down]} ]] && bindkey "${key[Down]}" down-line-or-search
[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char

#completion in the middle of a line
bindkey '^i' expand-or-complete-prefix

bindkey -M menuselect '/' accept-and-infer-next-history
bindkey -M menuselect '^F' accept-and-infer-next-history
bindkey -M menuselect "${key[Backspace]}" undo

# the gnu-utils plugin doesn't seem to finish loading
# force it to refresh
[[ ${plugins[(r)gnu-utils]} == gnu-utils ]] && hash -r

return 0
