source "$VIRO_HOME/src/utils.sh"

VIRO_ENV="$VIRO_HOME/user/ENV"

case "$1" in
  add)
    name="${2:-"$(prompt "add:")"}"
    name="${name^^}"
    [[ -z "$name" ]] && log "Name empty. No ENV has been created" && exit 1
    if ! viro env has "$name" || yorn "$(bold "$name") already exists. Replace it?"; then
      value="${@:3}"
      value="${value:-"$(prompt "$name should be:")"}"
      [[ -f "$value" ]] && log "Value empty. $name $(bold has not) been created" && exit 1
      [[ -e "$(dirname "$VIRO_ENV")" ]] && mkdir -p "$(dirname "$VIRO_ENV")"
      [[ -f "$VIRO_ENV" ]] && sed -i "/export $name=/d" "$VIRO_ENV"
      echo "export $name=\"$value\"" >> "$VIRO_ENV"
      log "added: $(grep "export $name" "$VIRO_ENV")"
      refresh
    else
      log "$name $(bold has not) been updated" && exit 1
    fi
    ;;
  edit) "$VISUAL" "$VIRO_ENV" && refresh;;
  rm)
    name="${2:-"$(sed -e 's/=./ /' < "$VIRO_ENV" | awk '{print $2}' | choose)"}"
    [[ -z "$name" ]] && log "No ENV have been removed" && exit 1
    name="${name^^}"
    if yorn "Are you sure you want to delete $name?"; then
      log "removed: $(grep "export $name" "$VIRO_ENV")"
      sed -i "/export $name=/d" "$VIRO_ENV"
      refresh
    else
      log "$name $(bold has not) been removed"
    fi
    ;;
  has) viro env ls | grep -wq "${2^^}";;
  ls|*) sed -e 's/export //' -e 's/=/~/' -e "s/'//g" < "$VIRO_ENV" | column -t -s~;;
esac
