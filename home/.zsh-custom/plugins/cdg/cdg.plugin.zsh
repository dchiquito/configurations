
# GIT_ROOT should be set in your .zshrc
# If it isn't set, just assume ~/git
local DEFAULT_GIT_ROOT=~/git

function _cdg () {
  local repos=`ls ${GIT_ROOT:-${DEFAULT_GIT_ROOT}}`
  _arguments -C \
    "-h[Show help information]" \
    "1: :(${repos})" \
    "*::arg:->args"
}

function cdg () {
  cd ${GIT_ROOT:-${DEFAULT_GIT_ROOT}}/$1
}

compdef _cdg cdg
