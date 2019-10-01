source "$VIRO_HOME/src/utils.sh"

VIRO_ALIAS="$VIRO_HOME/user/aliases"

case "$1" in
  add)
    name="${2:-"$(prompt "add:")"}"
    [[ -z "$name" ]] && log "Name empty. No alias has been created" && exit 1
    if ! viro alias has "$name" || yorn "$(bold "$name") already exists. Replace it?"; then
      cmd="${@:3}"
      cmd="${cmd:-"$(prompt "$name should:")"}"
      [[ -f "$cmd" ]] && log "Command empty. $name $(bold has not) been created" && exit 1
      [[ -e "$(dirname "$VIRO_ALIAS")" ]] && mkdir -p "$(dirname "$VIRO_ALIAS")"
      [[ -f "$VIRO_ALIAS" ]] && sed -i "/$name=/d" "$VIRO_ALIAS"
      echo "alias $name=\"$cmd\"" >> "$VIRO_ALIAS"
      log "added: $(bold "alias $name=\"$cmd\"")"
      refresh
    else
      log "$name (bold has not) been updated" && exit 1
    fi
    ;;
  edit) "$VISUAL" "$VIRO_ALIAS" && refresh;;
  rm)
    name="${2:-"$(sed -e 's/=./ /' < "$VIRO_ALIAS" | awk '{print $2}' | choose)"}"
    [[ -z "$name" ]] && log "No aliases have been removed" && exit 1
    if yorn "Are you sure you want to delete $name?"; then
      log "removed: $name"
      sed -i "/$name=/d" "$VIRO_ALIAS"
      refresh
    else
      log "$name $(bold has not) been removed"
    fi
    ;;
  has) viro alias ls | grep -wq "${@:2}";;
  ls|*) [[ -f "$VIRO_ALIAS" ]] && sed -e "s/=/~/" -e "s/alias //" -e "s/'//g" < "$VIRO_ALIAS" | column -t -s~;;
esac
