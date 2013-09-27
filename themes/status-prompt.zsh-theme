#!/usr/bin/env zsh

function zle-keymap-select zle-line-init zle-line-finish {
  # The terminal must be in application mode when ZLE is active for $terminfo
  # values to be valid.
  if (( ${+terminfo[smkx]} )); then
    printf '%s' ${terminfo[smkx]}
  fi
  if (( ${+terminfo[rmkx]} )); then
    printf '%s' ${terminfo[rmkx]}
  fi

  zle reset-prompt
  zle -R
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

bindkey -v

function vi_mode_prompt_info() {
  echo "${${KEYMAP/vicmd/ß}/(main|viins)/%#}"
}

local reset="%{$reset_color%}"
local cyan="%{$fg_bold[cyan]%}"
local yellow="%{$fg_bold[yellow]%}"
local blue="%{$fg_bold[blue]%}"
local green="%{$fg_bold[green]%}"
local magenta="%{$fg_bold[magenta]%}"
local status_color="%{%(?.$fg_no_bold[green].$fg_bold[red])%}"

local prefix="${status_color}[${reset}"
local user="${cyan}%n${reset}"
local at="${yellow}@${reset}"
local host="${cyan}%m${reset}"
local on="${status_color}:${reset}"
local cwd="${blue}%1~${reset}"
local suffix="${status_color}]"$'$(vi_mode_prompt_info)'"${reset}"

PROMPT="${prefix}${user}${at}${host}${on}${cwd}${suffix} "
unset status_color prefix user at host on cwd suffix

autoload -Uz vcs_info

zstyle ':vcs_info:*' enable svn git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' unstagedstr   "$yellow●$reset"
zstyle ':vcs_info:*' stagedstr     "$green●$reset"

precmd() {
    local reset="%{$reset_color%}"
    local red="%{$fg_bold[red]%}"
    local cyan="%{$fg_no_bold[cyan]%}"
    local blue="%{$fg_bold[blue]%}"

    local branchstr="$cyan%b$reset"
    local untrackedstr="$red●$reset"
    local repostr="$blue%r$reset"

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

ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="$magenta↓$reset"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="$magenta↑$reset"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="$magenta↕$reset"

unset reset cyan yellow blue green magenta status_color
