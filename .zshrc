#-------------------- exports --------------------

# Special CSE 481 names:
export BFBUILD="${HOME}/aos_proj/build_milestone_1"
export BFAOS="${HOME}/aos_proj/bf_aos"

# export PATH="$PATH:~/.local/bin/:~/scripts:$HOME/.cargo/bin"

# for reu xilinx
export PATH=/opt/Xilinx/Vivado/2024.1/bin:$PATH
export PATH=/opt/Xilinx/PetaLinux/2024.1/tool:$PATH
alias plinux="startPetaLinux2024_1.sh"

export EDITOR="nvim"
export VISUAL="nvim"
# export BROWSER="firefox-bin"
export AOSREPO="https://gitlab.cs.washington.edu/simpeter/aos.git"

export LATEXINDENT_CONFIG="/home/nash/.config/latexindent/latexindent.yaml"
 
# $HOME/.config/latexindent/latexindent.yaml"

# change colors of directories listed by ls to light purple 
LS_COLORS=$LS_COLORS:"di=1;95:" ; export LS_COLORS  

#-------------------- prompt --------------------

autoload -U colors && colors
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# add an empty line before each prompt
precmd() { echo }

#-------------------- vi mode --------------------

# enable vi mode and bind to ctrl-v
bindkey -v
bindkey -M viins "" vi-cmd-mode
bindkey -v "^?" backward-delete-char
KEYTIMEOUT=1

# edit current command with neovim using ctrl-e
autoload -z edit-command-line
zle -N edit-command-line
bindkey "" edit-command-line

#-------------------- tab completion --------------------

# enable tab completion menu
autoload -U compinit
zstyle ":completion:*" menu select
zmodload zsh/complist
compinit
# show hidden files
_comp_options+=(globdots)

# configure vi hjkl-motions for tab completion menu
bindkey  -M menuselect "h" vi-backward-char
bindkey  -M menuselect "j" vi-down-line-or-history
bindkey  -M menuselect "k" vi-up-line-or-history
bindkey  -M menuselect "l" vi-forward-char


#-------------------- cursor --------------------

# functions for setting cursor style
set_cursor_block () {
    echo -ne "\e[1 q"
}

set_cursor_beam () {
    echo -ne "\e[5 q"
}

# set cursor on startup
set_cursor_beam

# set cursor on new prompt
precmd_functions+=(set_cursor_beam)

# set cursor based on current vi mode
zle-keymap-select () {
    # normal mode
    if [[ $KEYMAP == vicmd ]] || 
        [[ $1 = block ]]; then
        set_cursor_block

    # insert mode
    elif [[ $KEYMAP == main ]] ||
        [[ $KEYMAP == viins ]] ||
        [[ $KEYMAP == "" ]] ||
        [[ $1 == beam ]]; then
        set_cursor_beam
    fi
}
zle -N zle-keymap-select

#-------------------- history --------------------

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history
# don't save command if identical to previous command 
setopt HIST_IGNORE_ALL_DUPS
# save after every command instead of on exit
setopt INC_APPEND_HISTORY
# use shared history for up/down-line between shells
setopt SHARE_HISTORY

# enable reverse search
bindkey -M viins "" history-incremental-search-backward

#-------------------- aliases --------------------

# alias vim="nvim"
# alias cat="bat"
# alias aella="ssh -J nashr2@attu.cs.washington.edu nashr2@aella.cs.washington.edu"
alias ptc="ssh -J nashr2@attu.cs.washington.edu nash@ptc.cs.washington.edu"
alias e="emacsclient"

# replace ls with eza
# Note we now never show ~ files which might be an issue
# Except with ls -I "" which overrides the previous -I
base_ls="eza --group-directories-first --icons=auto --git -h -I '*~'"
alias ls=$base_ls
alias lsl="${base_ls} -l"
# list directories only 
alias lsd="${base_ls} -D"
# list files only 
alias lsf="${base_ls} -f"

# ask before removing
# alias rm="rm -i"
# alias rmd="rm -Ir"
#
# alias df="df -h"

# alias zathura="zathura --fork"

alias grep="grep --color=auto"
# alias egrep="egrep --color=auto"
# alias fgrep="fgrep --color=auto"

#-------------------- customizations --------------------

# This is done to give the proper title to new vterm terminals
autoload -U add-zsh-hook
add-zsh-hook -Uz chpwd (){ print -Pn "\e]2;%2~\a" }

# -------------- Vterm configurations (shell side) ------------
vterm_printf() {
    if [ -n "$TMUX" ] \
        && { [ "${TERM%%-*}" = "tmux" ] \
            || [ "${TERM%%-*}" = "screen" ]; }; then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

# directory and prompt tracking:
vterm_prompt_end() {
    vterm_printf "51;A$(whoami)@$(hostname):$(pwd)"
}
setopt PROMPT_SUBST
PROMPT=$PROMPT'%{$(vterm_prompt_end)%}'

# --------- Venv aliases (allow quicker activating and dactivating) -------
# Quick venv activation
# type either venv or venv myproject (to activate by name)
venv() {
    if [ -z "$1" ]; then
        # Look for common venv directories in current folder
        for venv_dir in venv .venv env .env; do
            if [ -d "$venv_dir" ]; then
                source "$venv_dir/bin/activate"
                echo "Activated: $venv_dir"
                return
            fi
        done
        echo "No virtual environment found in current directory"
    else
        # Activate specific venv by name/path
        if [ -d "$1" ]; then
            source "$1/bin/activate"
        elif [ -d "$HOME/venvs/$1" ]; then
            source "$HOME/venvs/$1/bin/activate"
        else
            echo "Virtual environment '$1' not found"
        fi
    fi
}

# Quick deactivation
# Simply type dvenv
dvenv() {
    if [ -n "$VIRTUAL_ENV" ]; then
        deactivate
    else
        echo "No virtual environment is currently active"
    fi
}

#-------------------- ssh agent --------------------
# Requires keychain package installed
eval $(keychain --eval --quiet id_ed25519 cse_481)

#-------------------- syntax highlighting --------------------

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#-------------------- run on startup --------------------

date
# ufetch
