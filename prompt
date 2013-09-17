#!/bin/zsh

# include color stuff and prompt updating stuff
setopt prompt_subst
autoload colors    
colors

# set some colors
for COLOR in RED GREEN YELLOW WHITE BLACK CYAN; do
    eval PR_$COLOR='%{$fg[${(L)COLOR}]%}'         
    eval PR_BRIGHT_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done                                                 
PR_RESET="%{${reset_color}%}";  

PR_VIMODE="%#"
PR_VICOLOR=${PR_BLUE}                                                                
function zle-line-init zle-keymap-select {                                           
    PR_VIMODE="${${KEYMAP/vicmd/ß}/(main|viins)/%#}"                              
    PR_VICOLOR="${${KEYMAP/vicmd/${PR_RED}}/(main|viins)/${PR_GREEN}}"           
    zle reset-prompt                                                             
}                                                                                    
zle -N zle-line-init                                                                 
zle -N zle-keymap-select   

export PS1="%(?.${PR_GREEN}.${PR_BRIGHT_RED})[${PR_BRIGHT_CYAN}%n${PR_BRIGHT_YELLOW}@${PR_BRIGHT_CYAN}%m%(?.${PR_GREEN}.${PR_BRIGHT_RED}):${PR_BRIGHT_YELLOW}%c${PR_RESET}%(?.${PR_GREEN}.${PR_BRIGHT_RED})%(?.${PR_GREEN}.${PR_BRIGHT_RED})]"$'${PR_VIMODE}'"${PR_RESET} "
