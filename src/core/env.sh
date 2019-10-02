source "$VIRO_HOME/src/utils.sh"

VIRO_ENV="$VIRO_HOME/user/ENV"

case "$1" in
  add)
    name="${2:-"$(prompt "add:")"}"
    name="${name^^}"
    [[ -z "$name" ]] && log "Name empty. No ENV has been created" && exit 1
    if ! viro env has "$name" || [[ -n "$YES" ]] || yorn "$(bold "$name") already exists. Replace it?"; then
      value="${@:3}"
      value="${value:-"$(prompt "$name should be:")"}"
      [[ -f "$value" ]] && log "Value empty. $name $(bold has not) been created" && exit 1
      [[ -e "$(dirname "$VIRO_ENV")" ]] && mkdir -p "$(dirname "$VIRO_ENV")"
      [[ -f "$VIRO_ENV" ]] && sed -i "/export $name=/d" "$VIRO_ENV"
      echo "export $name=\"$value\"" >> "$VIRO_ENV"
      log "added: export $name=\"$value"\"
    else
      log "$name $(bold has not) been updated" && exit 1
    fi
    ;;
  edit) "$VISUAL" "$VIRO_ENV" && refresh;;
  rm)
    names="${*:2}"
    names="${names:-"$(sed -e 's/=./ /' < "$VIRO_ENV" | awk '{print $2}' | choose)"}"
    [[ -z "$names" ]] && log "No ENV have been removed" && exit 1
    for name in $names; do
      name="${name^^}"
      if [[ -n "$YES" ]] || yorn "Are you sure you want to delete $name?"; then
        log "removed: $(grep "export $name" "$VIRO_ENV")"
        sed -i "/export $name=/d" "$VIRO_ENV"
      else
        log "$name $(bold has not) been removed"
      fi
    done
    ;;
  has) viro env ls | grep -wq "${2^^}";;
  import)
    grep -vE "(VIRO_HOME|PATH)" "$HOME/.bashrc" | grep -E "export" | while read -r env; do
      name="$(echo "$env" | sed 's/=/ /' | awk '{print $2}')"
      value="$(echo "$env" | sed "s/export .*=//")"
      viro env add "$name" "$value" "$([[ -n "$YES" ]] && echo "--yes")" \
        && sed -i "/export $name/d" "$HOME/.bashrc"
    done
    ;;
  ls|*) sed -e 's/export //' -e 's/=/~/' -e "s/'//g" < "$VIRO_ENV" | column -t -s~;;
esac
