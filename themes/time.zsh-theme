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

# Update when line is initially created
zle -N zle-line-init
# Update when a command is finished
zle -N zle-line-finish
# Update when entering vi mode
zle -N zle-keymap-select

# Force viins as the default mode
bindkey -v

function battery_prompt_indicator {
  local size
  [ -z $BATTERY_INDICATOR_SIZE ] \
    && size=10 \
    || size=$BATTERY_INDICATOR_SIZE
  (( $size <= 1 )) && size=10
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
    # At >95%, show a full charge indicator
    (( pct > 95 || (i*100/size) < pct )) \
      && indicator+=$chrg \
      || indicator+=$uchrg
  done

  echo "$color$indicator$reset"
}

function git_prompt {
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

  [ -f "$head" ] && ref="$(cat "$head")" \
    || ref=$(git symbolic-ref HEAD 2> /dev/null) \
    || ref=$(git rev-parse --short HEAD 2> /dev/null)

  prefix="$ZSH_THEME_GIT_PROMPT_PREFIX"
  suffix="$ZSH_THEME_GIT_PROMPT_SUFFIX"
  b_color="%{$ZSH_THEME_GIT_PROMPT_BRANCH_COLOR%}"
  s_color="%{$ZSH_THEME_GIT_PROMPT_STATE_COLOR%}"
  reset="%{$reset_color%}"

  ref="${ref#refs/heads/}"
  remote="$(git_remote_status)"
  files="$(git_prompt_status)"
  echo "${prefix}${remote}${b_color}${ref}${reset}${state:+|$s_color$state$reset}${files}${suffix}"
}

#function put_prompt_spacing {
#  function clean {
#    local zero='%([BSUbfksu]|([FB]|){*})'
#    echo ${(S%%)1//$~zero/}
#  }
#  local len=$COLUMNS
#  local bat=$(battery_prompt_indicator)
#  args=("$USER" " at " "${HOST/.*/}" " in " "${PWD/#$HOME/~}" "$(git_prompt)" "$(clean $bat)")
#  echo $args > ~/.debug
#  for arg in $args;do
#    echo $arg - ${#arg} >> ~/.debug
#    len=$(($len - ${#arg}))
#  done
#  # Start at 2 to make it a little shorter
#  for i in {2..$len};do
#    spacing=\ $spacing
#  done
#  echo $spacing
#}

# Wrap in an anonymous function so local variables don't escape
function {
  local reset="%{$reset_color%}"
  local red="%{$fg_bold[red]%}"
  local cyan="%{$fg_bold[cyan]%}"
  local blue="%{$fg_bold[blue]%}"
  local green="%{$fg_bold[green]%}"
  local yellow="%{$fg_bold[yellow]%}"
  local magenta="%{$fg_bold[magenta]%}"
  local status_color="%{%(?.$fg_no_bold[green].$fg_bold[red])%}"

  local prefix=$'\n'
  local user="${fg_no_bold[magenta]}%n${reset}"
  local _at_=" at "
  local host="${fg_no_bold[cyan]}%m${reset}"
  local _in_=" in "
  local cwd="${blue}%~${reset}"
  local prompt_char=$'$(
    function {
      echo "${${KEYMAP/vicmd/ß}/(main|viins)/%#}"
    }
  )'
  local suffix=$'$(git_prompt)\n'"(%*) ${status_color}${prompt_char}${reset} "

  ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="$magenta↓$reset"
  ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="$magenta↑$reset"
  ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="$magenta↕$reset"

  ZSH_THEME_GIT_PROMPT_PREFIX=" on "
  ZSH_THEME_GIT_PROMPT_SUFFIX="${reset}"
  ZSH_THEME_GIT_PROMPT_BRANCH_COLOR="${fg_no_bold[green]}"

  # We're doing our own dirty indicators
  ZSH_THEME_GIT_PROMPT_DIRTY=""
  ZSH_THEME_GIT_PROMPT_CLEAN=""
  ZSH_THEME_GIT_PROMPT_ADDED="$green+$reset"
  ZSH_THEME_GIT_PROMPT_MODIFIED="$yellow●$reset"
  ZSH_THEME_GIT_PROMPT_DELETED="$red✗$reset"
  ZSH_THEME_GIT_PROMPT_RENAMED="$blue➦$reset"
  ZSH_THEME_GIT_PROMPT_UNMERGED="$magenta✂$reset"
  ZSH_THEME_GIT_PROMPT_UNTRACKED="$red✱$reset"

  PROMPT=${prefix}${user}${_at_}${host}${_in_}${cwd}${suffix}
}

# This enables the clock in the prompt to tick
TMOUT=1
TRAPALRM() {
  zle reset-prompt
}

RPROMPT=$'$(battery_prompt_indicator)'
#RPROMPT='%D{%a %b %f}'
