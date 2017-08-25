# zsh configuration for all sessions

############################################################
# Global Settings
############################################################

# Locale
export LANG=en_US.UTF-8

# umask
umask 0077

# don't store core dumps
ulimit -c 0

############################################################
# Paths
############################################################

# the location of the directory containing my zsh files
myzsh="${ZDOTDIR:-$HOME}/.myzsh.d"

typeset -gU path           # no dupes in path, keep leftmost
path=(~/bin $path)
