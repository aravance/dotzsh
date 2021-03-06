#!/usr/bin/env zsh

function zle-keymap-select zle-line-init zle-line-finish {
  # The terminal must be in application mode when ZLE is active for $terminfo
  # values to be valid.
  if (( ${+terminfo[smkx]} ));then
    printf '%s' ${terminfo[smkx]}
  fi
  if (( ${+terminfo[rmkx]} ));then
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

setup_prompt() {
  local reset="%{$reset_color%}"
  local red="%{$fg_bold[red]%}"
  local cyan="%{$fg_bold[cyan]%}"
  local blue="%{$fg_bold[blue]%}"
  local green="%{$fg_bold[green]%}"
  local yellow="%{$fg_bold[yellow]%}"
  local magenta="%{$fg_bold[magenta]%}"
  local status_color="%{%(?.$fg_no_bold[green].$fg_bold[red])%}"

  local prefix="${status_color}[${reset}"
  local user="${cyan}%n${reset}"
  local at="${yellow}@${reset}"
  local host="${cyan}%m${reset}"
  local on="${status_color}:${reset}"
  local cwd="${blue}%1~${reset}"
  local suffix="${status_color}]"$'$(vi_mode_prompt_info)'"${reset}"

  ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="$magenta↓$reset"
  ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="$magenta↑$reset"
  ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="$magenta↕$reset"

  ZSH_THEME_GIT_PROMPT_ADDED="$green+$reset"
  ZSH_THEME_GIT_PROMPT_MODIFIED="$yellow●$reset"
  ZSH_THEME_GIT_PROMPT_DELETED="$red✗$reset"
  ZSH_THEME_GIT_PROMPT_RENAMED="$blue➦$reset"
  ZSH_THEME_GIT_PROMPT_UNMERGED="$magenta✂$reset"
  ZSH_THEME_GIT_PROMPT_UNTRACKED="$red✱$reset"

  PROMPT="${prefix}${user}${at}${host}${on}${cwd}${suffix} "
}
setup_prompt
unfunction setup_prompt

git_prompt() {
  local repo head state remote ref

  repo=$(git rev-parse --show-toplevel 2>/dev/null)
  [[ -z $repo ]] && return

  g=$repo/.git
  if [ -d "$g/rebase-merge" ];then
    head="$g/rebase-merge/head-name"
    if [ -f "$g/rebase-merge/interactive" ];then
      state="rebase-i"
    else
      state="rebase-m"
    fi
  elif [ -f "$g/MERGE_MODE" ];then
    state="merge"
  else
    if [ -d "$g/rebase-apply" ];then
      head="$g/rebase-apply/head-name"
      if [ -f "$g/rebase-apply/rebasing" ];then
        state="rebase"
      elif [ -f "$g/rebase-apply/applying" ];then
        state="am"
      else
        state="am/rebase"
      fi
    fi
  fi

  [ -f "$head" ] && ref="$(cat "$head")" || \
    ref=$(git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(git rev-parse --short HEAD 2> /dev/null)

  local blue green reset
  blue="%{$fg_bold[blue]%}"
  green="%{$fg_no_bold[green]%}"
  reset="%{$reset_color%}"

  repo="${blue}$(basename $repo)${reset}"
  ref="${green}${ref#refs/heads/}${reset}"
  remote="$(git_remote_status)"
  files="$(git_prompt_status)"
  echo "[${repo}:${remote}${ref}${state:+|$state}${files}]"
}

RPROMPT='$(git_prompt)'
