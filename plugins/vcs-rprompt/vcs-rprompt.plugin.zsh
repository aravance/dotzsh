#!/usr/bin/zsh

# include color stuff and prompt updating stuff
setopt prompt_subst
autoload colors    
colors

autoload -Uz vcs_info

local RESET="%{$reset_color%}"
local YELLOW="%{$fg_bold[yellow]%}"
local GREEN="%{$fg_bold[green]%}"

zstyle ':vcs_info:*' enable svn git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr   "$YELLOW●$RESET"
zstyle ':vcs_info:*' stagedstr     "$GREEN●$RESET"

precmd() {
    local RESET="%{$reset_color%}"
    local RED="%{$fg_bold[red]%}"
    local CYAN="%{$fg[cyan]%}"
    local BLUE="%{$fg_bold[blue]%}"

    local branchstr="$CYAN%b$RESET"
    local untrackedstr="$RED●$RESET"
    local repostr="$BLUE%r$RESET"

    if [[ -z $(git ls-files --other --exclude-standard 2>/dev/null) ]];then
      zstyle ':vcs_info:*' formats "[$repostr:$branchstr%c%u]"
      zstyle ':vcs_info:*' actionformats "[$repostr:$branchstr%c%u|%a]"
    else
      zstyle ':vcs_info:*' formats "[$repostr:$branchstr%c%u$untrackedstr]"
      zstyle ':vcs_info:*' actionformats "[$repostr:$branchstr%c%u$untrackedstr|%a]"
    fi

    vcs_info
}

export RPROMPT=$'$vcs_info_msg_0_'
