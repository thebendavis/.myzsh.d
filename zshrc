# zsh configuration for interactive shells

############################################################
# General Options
############################################################

# Expansion and Globbing
setopt EXTENDEDGLOB              # lots of extra globbing features
setopt BRACE_CCL                 # expand expressions in braces to a list of all chars

# Escape URLs
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# Safety
setopt NOCLOBBER                 # prevent accidential clobbering when doing stream redirection
setopt CORRECT                   # if command doesn't exist, look for correction
setopt RM_STAR_WAIT              # wait 10 seconds before running 'rm /foo/bar/*'

# Directory Management
setopt AUTO_CD                   # if type no-args, not-command will see if directory and cd
setopt AUTO_PUSHD                # auto do a pushd on every cd. list: dirs -v. switch: cd -<TAB>
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_MINUS               # reverse order so most recent is on top
setopt AUTO_NAME_DIRS            # use names of parameters containing dirs as names

# Job Control
setopt NO_HUP                    # background jobs keep running when shell exits (don't send HUP)
setopt LONG_LIST_JOBS            # use long format by default
unsetopt FLOW_CONTROL            # who needs this?

# make ^W chomp alphanumeric words only
autoload -Uz select-word-style
select-word-style bash

# zmv for mass renaming
autoload -Uz zmv


############################################################
# ZLE: Zsh line editing
############################################################

setopt EMACS
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M emacs '^X^E' edit-command-line


############################################################
# History
############################################################

HISTFILE="${ZDOTDIR:-$HOME}/.history"
HISTSIZE=10000
SAVEHIST=10000

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing non-existent history.
setopt HIST_ALLOW_CLOBBER        # when NOCLOBBER blocks, convert > to >| in hist for fast retry


############################################################
# Completion
############################################################

fpath=("${myzsh}/completions" $fpath)
zmodload zsh/complist
autoload -Uz compinit && compinit

setopt COMPLETE_IN_WORD          # Complete from both ends of a word.
setopt ALWAYS_TO_END             # Move cursor to the end of a completed word.
setopt PATH_DIRS                 # Perform path search even on command names with slashes.
setopt AUTO_MENU                 # Show completion menu on a succesive tab press.
setopt AUTO_LIST                 # Automatically list choices on ambiguous completion.
setopt AUTO_PARAM_SLASH          # If completed parameter is a directory, add a trailing slash.
unsetopt MENU_COMPLETE           # Do not autoselect the first completion entry.

# use caching (?)
#zstyle ':completion::complete:*' use-cache on
#zstyle ':completion::complete:*' cache-path "${ZDOTDIR:-$HOME}/.zcompcache"

# partial-word and substring completion (case-senstive)
zstyle ':completion:*' matcher-list 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# verbose, unless set otherwise
zstyle ':completion:*' verbose yes

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# Fuzzy match mistyped completions.
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Increase the number of errors based on the length of the typed word.
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

# Don't complete unavailable commands.
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'

# Array completion element sorting.
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Directories
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*' squeeze-slashes true

# History
zstyle ':completion:*:history-words' stop yes
zstyle ':completion:*:history-words' remove-all-dups yes
zstyle ':completion:*:history-words' list false
zstyle ':completion:*:history-words' menu yes

# Environmental Variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

#-----------------------------------------------------------
# specific completions
#

# Kill
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;36=0=01'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*' insert-ids single

# Man
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true


############################################################
# My Functions
############################################################

# add zfuncs dir to fpath and autoload every function
typeset -gU fpath
if [[ -d "${myzsh}/zfuncs" ]]; then
    fpath=( "${myzsh}/zfuncs" "${fpath[@]}" )

    for f in ${myzsh}/zfuncs/*(.); do
        autoload -Uz ${f:t}
    done
fi

# Prompt/Theme UI Setup
prompt_ben_setup


############################################################
# Aliases
############################################################

if [[ -r "${myzsh}/zaliases" ]]; then
    . "${myzsh}/zaliases"
fi

############################################################
# Alias-Based Environment Variables (in "${myzsh}/zaliases")
############################################################

export EDITOR="${myemacsc}"
export VISUAL="${myemacsc}"


############################################################
# Third-Party Plugins
############################################################

if [[ -d "${myzsh}/plugins" ]]; then
    # syntax highlighting (load before history-substring-search)
    source "${myzsh}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

    # history substring search (load after synatx-highlighting)
    source "${myzsh}/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"

    # type anything from a previous command and use ^P and ^N to search
    bindkey -M emacs '^P' history-substring-search-up
    bindkey -M emacs '^N' history-substring-search-down
fi


############################################################
# Machine-Local Config
############################################################

if [[ -r "${ZDOTDIR:-$HOME}/.zlocal" ]]; then
    . "${ZDOTDIR:-$HOME}/.zlocal"
fi
