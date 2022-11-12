declare -A __pr_c_cache
__pr_c() {
  __pr_c_eval "$1" && printf "%s" "${__pr_c_cache["$1"]}"
}

__pr_c_tput() {
  local v=$(tput "$@") && printf "\[%s\]" "$v"
}

__pr_c_eval() {
  [[ ${__pr_c_cache["$1"]+1} ]] && return

  local v=""
  case "$1" in
    bg-black)   v="$(__pr_c_tput setab 0)";;
    bg-red)     v="$(__pr_c_tput setab 1)";;
    bg-green)   v="$(__pr_c_tput setab 2)";;
    bg-yellow)  v="$(__pr_c_tput setab 3)";;
    bg-blue)    v="$(__pr_c_tput setab 4)";;
    bg-magenta) v="$(__pr_c_tput setab 5)";;
    bg-cyan)    v="$(__pr_c_tput setab 6)";;
    bg-white)   v="$(__pr_c_tput setab 7)";;
    fg-black)   v="$(__pr_c_tput setaf 0)";;
    fg-red)     v="$(__pr_c_tput setaf 1)";;
    fg-green)   v="$(__pr_c_tput setaf 2)";;
    fg-yellow)  v="$(__pr_c_tput setaf 3)";;
    fg-blue)    v="$(__pr_c_tput setaf 4)";;
    fg-magenta) v="$(__pr_c_tput setaf 5)";;
    fg-cyan)    v="$(__pr_c_tput setaf 6)";;
    fg-white)   v="$(__pr_c_tput setaf 7)";;
    tx-bold)    v="$(__pr_c_tput bold)";;
    tx-dim)     v="$(__pr_c_tput dim)";;
    tx-rev)     v="$(__pr_c_tput rev)";;
    tx-smul)    v="$(__pr_c_tput smul)";;
    tx-rmul)    v="$(__pr_c_tput rmul)";;
    tx-smso)    v="$(__pr_c_tput smso)";;
    tx-rmso)    v="$(__pr_c_tput rmso)";;
    tx-reset)   v="$(__pr_c_tput sgr0)";;
    shell)      v="$(basename "$SHELL")";;
    has-title)  v="$( (tput tsl && tput fsl) &> /dev/null && echo yes )";;
    to-title)   v="$(__pr_c_tput tsl)";;
    from-title) v="$(__pr_c_tput fsl)";;
    *)          return 1;;
  esac

  __pr_c_cache["$1"]="$v"
}

__pr_generate() {
  local previous_status=$1

  local cwd="$(__pr_c fg-green)\w$(__pr_c tx-reset)"

  if (( previous_status != 0 )); then
    local status="$(__pr_c fg-red)‡$(__pr_c tx-reset)"
  else
    local status="$(__pr_c fg-magenta)‡$(__pr_c tx-reset)"
  fi

  local host="$(__pr_c fg-cyan)\h$(__pr_c tx-reset)"
  local user="$(__pr_c fg-blue)\u$(__pr_c tx-reset)"

  local prompt="$cwd\n$status "
  local title="$(__pr_c shell) in \w"

  if (( EUID == 0 )); then
    user="$(__pr_c fg-red)\u$(__pr_c tx-reset)"
    prompt="$user in $cwd\n$status "
  fi

  if [[ -n "$SSH_TTY" ]]; then
    prompt="$user at $host in $cwd\n$status "
    title="$(__pr_c shell) at \h in \w"
  fi

  if [[ -n "$(__pr_c has-title)" ]]; then
    prompt="$(__pr_c to-title)$title$(__pr_c from-title)$prompt"
  fi

  printf "%s" "$prompt"
}

__pr_hook() {
  local previous_exit_status=$?
  trap -- "" SIGINT
  PS1="$(__pr_generate $previous_exit_status)"
  trap - SIGINT
  return $previous_exit_status
}

if [[ "$TERM" != "dumb" ]]; then
  PROMPT_COMMAND="__pr_hook"
fi
