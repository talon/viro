source "$VIRO_HOME/src/utils.sh"

VIRO_ENV="$VIRO_HOME/user/ENV"

[[ -e "$(dirname "$VIRO_ENV")" ]] && mkdir -p "$(dirname "$VIRO_ENV")"
case "$1" in
  set)
    name="${2:-"$(prompt "viro env set")"}"
    viro env has "$name" && ! yorn "replace $(bold "${name^^}")?" "$YES" && exit 1

    value="${@:3}"
    value="${value:-"$(prompt "viro env set $name")"}"

    [[ -f "$VIRO_ENV" ]] && sed -i "/export ${name^^}=/d" "$VIRO_ENV"
    echo "export ${name^^}=\"$value\"" >> "$VIRO_ENV"
    ;;
  get)
    name="${2:-"$(viro env | choose "viro env get" | awk '{print $1}')"}"
    if [[ -n "$name" ]]; then
      viro env has "$name" || viro env set "$name" "$3"
    fi
    grep -w "${name^^}=" "$VIRO_ENV" | awk -F = '{print $2}' | sed 's/"//g'
    ;;
  rm)
    names="${*:2}"
    names="${names:-"$(viro env | choose "viro env rm")"}"
    names="${names:-"$(sed -e 's/=./ /' < "$VIRO_ENV" | awk '{print $2}' | choose "viro env rm")"}"
    for name in $names; do
      name="${name^^}"
      if yorn "viro env rm $name?" "$YES"; then
        sed -i "/export $name=/d" "$VIRO_ENV"
      fi
    done
    ;;
  has) viro env | grep -wq "${2^^}";;
  import)
    grep -vE "(VIRO_HOME|PATH)" "$HOME/.bashrc" | grep -E "export" | while read -r env; do
      name="$(echo "$env" | sed 's/=/ /' | awk '{print $2}')"
      value="$(echo "$env" | sed "s/export .*=//")"
      YES="y" viro env set "$name" "$value" \
        && sed -i "/export $name/d" "$HOME/.bashrc"
    done
    ;;
  edit) "$VISUAL" "$VIRO_ENV" && refresh;;
  *) sed -e 's/export //' -e 's/=/~/' -e "s/['\"]//g" < "$VIRO_ENV" | column -t -s~;;
esac
