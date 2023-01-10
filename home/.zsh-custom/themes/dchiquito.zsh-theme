# Based on gnzh theme

local function _project_name(){
  echo `basename \`git rev-parse --show-toplevel\``
}

local function _prompt() {
  local git_branch="$(git_prompt_info)"
  if [[ -n "${git_branch}" ]]; then
    # We are in a git repo, so show the git branch + status symbol
    # To save space, do not show the whole path to the project
    local absolute_current_dir=`pwd`
    local project_root=`git rev-parse --show-toplevel` # The repository path
    local project_name=`basename ${project_root}` # The name of the repository
    local python_files=(*.py(N))
    local num_python_files=${#python_files}
    if [[ -n ${VIRTUAL_ENV} ]] && [[ ${VIRTUAL_ENV:t} ==  ${project_name}* ]]; then
      # The name matches the repository, as we expect when the virtualenvwrapper plugin works correctly.
      # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/virtualenvwrapper
      # To save space, show the project in green to indicate the venv is active
      echo "%F{green}%B${project_name}%b%f%F{blue}${absolute_current_dir#$project_root}%f ${git_branch}"
    elif [[ -n ${VIRTUAL_ENV} ]]; then
      # The venv name does not match the project.
      # Show the project in blue and the venv separately in red
      echo "%F{blue}%B${project_name}%b${absolute_current_dir#$project_root}%f %F{red}‹${VIRTUAL_ENV:t}›%f ${git_branch}"
    elif [ $num_python_files -gt 0 ]; then
      # We're in a python project, but there is no venv.
      # Show a notice that the venv is missing; a warning is better than accidentally using the system python
      echo "%F{blue}%B${project_name}%b${absolute_current_dir#$project_root}%f %F{red}‹no venv›%f ${git_branch}"
    else
      # We're in a non-python project, don't show anything venv related.
      echo "%F{blue}%B${project_name}%b${absolute_current_dir#$project_root}%f ${git_branch}"
    fi

  else
    # We are not in a git branch.
    # Show the path and the virtualenv, if any
    local current_dir="%B%F{blue}%~%f%b"
    echo "${current_dir} $(virtualenv_prompt_info)"
  fi
}

local function _ssh() {
  if [[ -n "$SSH_CLIENT" || -n "$SSH2_CLIENT" ]]; then
    echo "%K{blue}%B%M%b%k "
  fi
}

setopt prompt_subst

() {

#PROMPT="╭─ \$(_prompt)
#╰─%f➤ %f"
PROMPT="╭─ $(_ssh)\$(_prompt)
╰─▶ "

local return_code="%(?..%F{red}%? ↵%f)"
RPROMPT="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%F{yellow}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %f"
ZSH_THEME_VIRTUALENV_PREFIX="%F{green}‹"
ZSH_THEME_VIRTUALENV_SUFFIX="›%f"

}
