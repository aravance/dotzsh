#!/usr/bin/env zsh

local RESET="%{$reset_color%}"

local STATUS_COLOR="%{%(?.$fg_no_bold[green].$fg_bold[red])%}"
local USER_COLOR="%{$fg_bold[cyan]%}"
local AT_COLOR="%{$fg_bold[yellow]%}"
local HOST_COLOR="%{$fg_bold[cyan]%}"
local PWD_COLOR="%{$fg_bold[yellow]%}"

PROMPT="${STATUS_COLOR}[${USER_COLOR}%n${AT_COLOR}@${HOST_COLOR}%m${STATUS_COLOR}:${PWD_COLOR}%c${STATUS_COLOR}]%%${RESET} "

autoload -Uz vcs_info

local YELLOW="%{$fg_bold[yellow]%}"
local GREEN="%{$fg_bold[green]%}"
local MAGENTA="%{$fg_bold[magenta]%}"

zstyle ':vcs_info:*' enable svn git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr   "$YELLOW●$RESET"
zstyle ':vcs_info:*' stagedstr     "$GREEN●$RESET"

precmd() {
    local RESET="%{$reset_color%}"
    local RED="%{$fg_bold[red]%}"
    local CYAN="%{$fg_no_bold[cyan]%}"
    local BLUE="%{$fg_bold[blue]%}"

    local branchstr="$CYAN%b$RESET"
    local untrackedstr="$RED●$RESET"
    local repostr="$BLUE%r$RESET"

    if [[ -z $(git ls-files --other --exclude-standard 2>/dev/null) ]];then
      zstyle ':vcs_info:*' formats "[$repostr:$(git_remote_status)$branchstr%c%u]"
      zstyle ':vcs_info:*' actionformats "[$repostr:$(git_remote_status)$branchstr%c%u|%a]"
    else
      zstyle ':vcs_info:*' formats "[$repostr:$(git_remote_status)$branchstr%c%u$untrackedstr]"
      zstyle ':vcs_info:*' actionformats "[$repostr:$(git_remote_status)$branchstr%c%u$untrackedstr|%a]"
    fi

    vcs_info
}

RPROMPT=$'$vcs_info_msg_0_'

ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="$MAGENTA↓$RESET"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="$MAGENTA↑$RESET"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="$MAGENTA↕$RESET"
