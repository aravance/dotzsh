#!/usr/bin/env zsh

local NORMAL="0"
local BOLD="1"
local UNDERLINE="4"
local FLASH="5"
local BLACK="30"
local RED="31"
local GREEN="32"
local YELLOW="33"
local BLUE="34"
local MAGENTA="35"
local CYAN="36"
local GREY="37"
local BG_BLACK="40"
local BG_RED="41"
local BG_GREEN="42"
local BG_YELLOW="43"
local BG_BLUE="44"
local BG_MAGENTA="45"
local BG_CYAN="46"
local BG_GREY="47"

local ls_colors
ls_colors=(
  "fi=$NORMAL"
  "di=$BOLD;$BLUE"
  "rs=$NORMAL"
  "ln=$BOLD;$CYAN"
  "mh=$NORMAL"
  "pi=$YELLOW;$BG_BLACK"
  "so=$BOLD;$MAGENTA"
  "do=$BOLD;$MAGENTA"
  "bd=$BOLD;$YELLOW;$BG_BLACK"
  "cd=$BOLD;$YELLOW;$BG_BLACK"
  "or=$BOLD;$RED;$BG_BLACK"
  "su=$GREY;$BG_RED"
  "sg=$BLACK;$BG_YELLOW"
  "ca=$BLACK;$BG_RED"
  "tw=$BLACK;$BG_GREEN"
  "ow=$BLUE;$BG_GREEN"
  "st=$GREY;$BG_BLUE"
  "ex=$BOLD;$GREEN"
)

add_type() {
  (( $# < 2 )) && return 1
  local color exts
  color=$1
  exts=($@[2,-1])
  for ext in $exts;do
    ls_colors+="*.$ext=$color"
  done
}

local exts

# archive types
exts=(tar tgz arj taz lzh lzma tlz txz apk zip z Z dz gz xz bz2 bz tbz tbz2 tz deb rpm jar rar ace zoo cpio 7z rz)
add_type "$BOLD;$RED" $exts

# music types
exts=(aac au flac mid midi mka m4a mp3 mpc ogg ra wav axa oga spx xspf) 
add_type "$CYAN" $exts

# photo types
exts=(jpg jpeg gif bmp pbm pgm ppm tga xbm xpm tif tiff pdn png svg svgz mng pcx xcf)
add_type "$MAGENTA" $exts

# video types
exts=(mov mpg mpeg m2v mkv ogm mp4 m4v mp4v vob wmv asf rm rmvb flc avi fli flv)
add_type "$MAGENTA" $exts

unset exts


export LS_COLORS="${(j.:.)ls_colors}:"
zstyle ':completion:*' list-colors $ls_colors
unset ls_colors
