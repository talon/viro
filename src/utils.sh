FILENAME="$( basename "${BASH_SOURCE[1]}" )"
FILENAME="${FILENAME:-"util"}"
FILENAME="${FILENAME%.*}"

refresh() { exec bash; }

log() { echo "[$FILENAME]" "$@"; }

prompt() { read -rp "[$FILENAME] $1 " value; echo "$value"; }

yorn() {
  read -n 1 -rp "[$FILENAME] $1 (y/N) " value;
  case "$value" in
    y|Y) echo && return 0;;
    *) return 1;;
  esac
}

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

bold() { echo "$(tput bold)$@$(tput sgr0)"; }
