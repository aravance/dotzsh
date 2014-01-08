#!/usr/bin/env zsh

battery_indicator() {
  local size
  [ -z $BATTERY_INDICATOR_SIZE ] \
    && size=10 \
    || size=$BATTERY_INDICATOR_SIZE
  local chrg=▮
  local uchrg=▯

  local pct=$(battery_pct_remaining)
  local yellow="%{$fg_bold[yellow]%}"
  local red="%{$fg_bold[red]%}"
  local green="%{$fg_bold[green]%}"
  local reset="%{$reset_color%}"

  local color=$green
  local charging=false
  if [[ -z $pct ]];then
    return
  elif [[ $pct == External ]];then
    color=$green
    charging=true
  elif (( $pct <= 20 ));then
    color=$red
  elif (( $pct <= 40));then
    color=$yellow
  fi

  local indicator
  $charging \
    && pct=$(battery_pct) \
    && chrg=▸ \
    && uchrg=▹
  [ ! -z $DEBUG_BATTERY_INDICATOR ] && echo "$color $charging $pct $reset" && return
  for i in {1..$size};do
    (( ($i*100/$size) < $pct )) \
      && indicator+=$chrg \
      || indicator+=$uchrg
  done

  echo "$color$indicator$reset"
}

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

  local color reset
  color="%{$fg_no_bold[yellow]%}"
  reset="%{$reset_color%}"

  ref="${color}${ref#refs/heads/}${reset}"
  remote="$(git_remote_status)"
  files="$(git_prompt_status)"
  echo "${remote}${ref}${state:+|$state}${files}"
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

  local prefix=""
  local user="${fg_no_bold[magenta]}%n${reset}"
  local at=" at "
  local host="${fg_no_bold[cyan]}%m${reset}"
  local on=" in "
  local cwd="${fg_no_bold[green]}%~${reset}"
  local suffix=$'\n'"(%*) ${status_color}%#${reset} "

  ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="$magenta↓$reset"
  ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="$magenta↑$reset"
  ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="$magenta↕$reset"

  ZSH_THEME_GIT_PROMPT_ADDED="$green+$reset"
  ZSH_THEME_GIT_PROMPT_MODIFIED="$yellow●$reset"
  ZSH_THEME_GIT_PROMPT_DELETED="$red✗$reset"
  ZSH_THEME_GIT_PROMPT_RENAMED="$blue➦$reset"
  ZSH_THEME_GIT_PROMPT_UNMERGED="$magenta✂$reset"
  ZSH_THEME_GIT_PROMPT_UNTRACKED="$red✱$reset"

  local git_prompt=$'$(                      \
    function {                               \
      local result=$(git_prompt)             \
      [ ! -z $result ] && echo " on $result" \
    }                                        \
  )'

  PROMPT=${prefix}${user}${at}${host}${on}${cwd}${git_prompt}${suffix}
}
setup_prompt
unfunction setup_prompt

# This enables the clock in the prompt to tick
TMOUT=1
TRAPALRM() {
  zle reset-prompt
}

RPROMPT='$(battery_indicator)'
