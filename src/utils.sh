prompt() {
  read -rp "$1 " value;
  [ -z "$value" ] && return 1;
  echo "$value";
}

yorn() {
  answer="$2"
  [ -z "$answer" ] && read -n 1 -rp "$1 (y/N) " answer && printf "\n"
  case "$answer" in
    y|Y) return 0;;
    *) return 1;;
  esac
}
