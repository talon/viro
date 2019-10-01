source "$VIRO_HOME/src/utils.sh"

VIRO_PATH="$VIRO_HOME/user/PATH"

case "$1" in
  add)
    directory="${2:-"$(prompt "add:")"}"
    directory="$(realpath "$directory")"
    [[ -z "$directory" ]] && log "your PATH $(bold has not) been modified" && exit 1
    viro path has "$directory" && log "$(bold "$directory") is already in your PATH" && exit 1
    echo "PATH=\"\$PATH:$directory\"" >> "$VIRO_PATH"
    log "added: $directory"
    refresh
    ;;
  edit) "$VISUAL" "$VIRO_PATH" && viro refresh;;
  rm)
    directory="${2:-"$(viro path ls | choose)"}"
    directory="$(realpath "$directory")"
    [[ -z "$directory" ]] && log "your PATH $(bold has not) been modified" && exit 1
    if yorn "remove $directory from your PATH?"; then
      sed -i "/$(echo "$directory" | sed 's/\//\\\//g')/d" "$VIRO_PATH"
      refresh
    else
      log "$directory $(bold has not) been removed from your PATH"
    fi
    ;;
  has) viro path ls | grep -wq "${@:2}";;
  ls|*) sed -e 's/PATH="$PATH://' -e 's/"//g' < "$VIRO_PATH";;
esac
