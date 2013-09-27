#!/usr/bin/env zsh
mvn-color() {
  # Filter mvn output using sed
  mvn $@ | sed -e "s/\(\[INFO\]\ \-.*\)/$fg_bold[blue]\1/g" \
               -e "s/\(\[INFO\]\ \[.*\)/$reset_color\1$reset_color/g" \
               -e "s/\(\[INFO\]\)\(\ .* SUCCESS\)/$fg_bold[blue]\1$fg_bold[green]\2$reset_color/g" \
               -e "s/\(\[INFO\]\)\(\ .* FAILURE\)/$fg_bold[blue]\1$fg_bold[red]\2$reset_color/g" \
               -e "s/\(\[INFO\]\)\(\ .* SKIPPED\)/$fg_bold[blue]\1$fg_bold[yellow]\2$reset_color/g" \
               -e "s/\(\[WARNING\].*\)/$fg_bold[yellow]\1$reset_color/g" \
               -e "s/\(\[ERROR\].*\)/$fg_bold[red]\1$reset_color/g" \
               -e "s/Tests run: \([^,]*\), Failures: \([^,]*\), Errors: \([^,]*\), Skipped: \([^,]*\)/$fg_bold[green]Tests run: \1$reset_color, Failures: $fg_bold[red]\2$reset_color, Errors: $fg_bold[red]\3$reset_color, Skipped: $fg_bold[yellow]\4$reset_color/g"
 
  # Make sure formatting is reset
  echo -ne $reset_color
}

alias -g mvn='mvn-color'
