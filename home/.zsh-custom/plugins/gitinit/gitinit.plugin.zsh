
# GIT_ROOT should be set in your .zshrc
# If it isn't set, just assume ~/git
# local DEFAULT_GIT_ROOT=~/git

function _gitinit () {
  local repos=`ls ${GIT_ROOT:-${DEFAULT_GIT_ROOT}}`
  _arguments -C \
    "-h[Show help information]" \
    "1: :(${repos})" \
    "*::arg:->args"
}

function gitinit () {
  cd ${GIT_ROOT:-${DEFAULT_GIT_ROOT}}
  local owner=$1
  local repo=$2
  git clone git@github.com:$owner/$repo.git
  cd $repo
  if [[ -e "setup.py" ]]; then
    mkvirtualenv $repo
    pip install -e .
  fi
}

compdef _gitinit gitinit
