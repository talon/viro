FILENAME="$( basename "${BASH_SOURCE[1]}" )"
FILENAME="${FILENAME:-"util"}"

log() { echo "[$FILENAME]" "$@"; }
prompt() { read -rp "[$FILENAME] $1 " value; echo "$value"; }
choose() {
  if [[ -n "$(command -v fzf)" ]]; then
    fzf
  else
    # hack to perserve whitespace from stdin
    local options=""
    while read -r value; do options="\"$value\" $options"; done
    eval set -- "$options"
    # /hack

    PS3="[$FILENAME] #? "
    select value in "$@"; do
      echo "$value"
      break
    done < /dev/tty
  fi
}
