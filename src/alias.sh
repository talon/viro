source "$VIRO_HOME/src/utils.sh"

VIRO_ALIAS="$VIRO_HOME/user/aliases"

case "$1" in
  add)
    name="${2:-"$(prompt "add:")"}"
    [[ -z "$name" ]] && log "Name empty. No alias has been created" && exit 1
    if ! viro alias has "$name" || yorn "$(bold "$name") already exists. Replace it?" "$YES"; then
      cmd="${@:3}"
      cmd="${cmd:-"$(prompt "$name should:")"}"
      [[ -f "$cmd" ]] && log "Command empty. $name $(bold has not) been created" && exit 1
      [[ -e "$(dirname "$VIRO_ALIAS")" ]] && mkdir -p "$(dirname "$VIRO_ALIAS")"
      [[ -f "$VIRO_ALIAS" ]] && sed -i "/$name=/d" "$VIRO_ALIAS"
      echo "alias $name=\"$cmd\"" >> "$VIRO_ALIAS"
      log "added: $(bold "alias $name=\"$cmd\"")"
    else
      log "$name $(bold has not) been updated" && exit 1
    fi
    ;;
  edit) "$VISUAL" "$VIRO_ALIAS";;
  rm)
    names="${*:2}"
    names="${names:-"$(sed -e 's/=./ /' < "$VIRO_ALIAS" | awk '{print $2}' | choose "viro alias rm")"}"
    [[ -z "$names" ]] && log "No aliases have been removed" && exit 1
    for name in $names; do
      if yorn "remove alias $(bold "$name")?" "$YES"; then
        sed -i "/$name=/d" "$VIRO_ALIAS"
      fi
    done
    ;;
  has) viro alias ls | grep -wq "${@:2}";;
  import)
    grep "alias" "$HOME/.bashrc" | while read -r alias; do
      name="$(echo "$alias" | sed 's/=/ /' | awk '{print $2}')"
      cmd="$(echo "$alias" | sed "s/alias .*=//")"
      viro alias add "$name" "$cmd" "$([[ -n "$YES" ]] && echo "--yes")" \
        && sed -i "/alias $name/d" "$HOME/.bashrc"
    done
    ;;
  ls|*) [[ -f "$VIRO_ALIAS" ]] && sed -e "s/=/~/" -e "s/alias //" -e "s/'//g" < "$VIRO_ALIAS" | column -t -s~;;
esac
