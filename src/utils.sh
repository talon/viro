FILENAME="$( basename "${BASH_SOURCE[1]}" )"
FILENAME="${FILENAME:-"util"}"
FILENAME="${FILENAME%.*}"

log() { echo "[$FILENAME]" "$@"; }

prompt() {
  read -rp "[$FILENAME] $1 " value;
  [[ -z "$value" ]] && exit 1
  echo "$value";
}

yorn() {
  answer="$2"
  [[ -z "$answer" ]] && read -n 1 -rp "[$FILENAME] $1 (y/N) " answer && printf "\n"
  case "$answer" in
    y|Y) return 0;;
    *) return 1;;
  esac
}

sel() {
  message="${1:-"[$FILENAME]:"}"
  [[ -n "$1" ]] && shift

  # hack to perserve whitespace from stdin
  local options=""
  while read -r value; do options="\"$value\" $options"; done
  eval set -- "$options"
  # /hack

  PS3="[$FILENAME] $message "
  select value in "$@"; do
    [[ -z "$value" ]] && exit 1
    echo "$value"
    break
  done < /dev/tty
}
