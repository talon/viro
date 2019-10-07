source "$VIRO_HOME/src/utils.sh"

VIRO_ENV="$VIRO_HOME/user/ENV"

[[ -e "$(dirname "$VIRO_ENV")" ]] && mkdir -p "$(dirname "$VIRO_ENV")"
case "$1" in
  set)
    name="${2:-"$(viro env | choose "viro env set" | awk '{print $1}')"}"
    [[ -n "$2" ]] && viro env has "$name" && ! yorn "replace ${name^^}?" "$YES" && exit 1

    value="${@:3}"
    value="${value:-"$(prompt "viro env set ${name^^}")"}"
    [[ -z "$value" ]] && exit 1

    [[ -f "$VIRO_ENV" ]] && sed -i "/export ${name^^}=/d" "$VIRO_ENV"
    echo "export ${name^^}=\"$value\"" >> "$VIRO_ENV"
    echo "$value"
    ;;
  get)
    name="${2:-"$(viro env | choose "viro env get" | awk '{print $1}')"}"
    value="$(printenv "${name^^}")"
    if [[ -n "$value" ]]; then
      echo "$value"
    else
      viro env set "$name" "$3"
    fi
    ;;
  rm)
    names="${*:2}"
    names="${names:-"$(sed -e 's/export //' -e 's/=/~/' -e "s/['\"]//g" < "$VIRO_ENV" | column -t -s~ | choose "viro env rm" | awk '{print $1}')"}"
    for name in $names; do
      name="${name^^}"
      if yorn "viro env rm $name?" "$YES"; then
        sed -i "/export $name=/d" "$VIRO_ENV"
        unset "$name"
      fi
    done
    ;;
  has) [[ -n "$(printenv "$2")" ]];;
  import)
    grep -vE "(VIRO_HOME|PATH)" "$HOME/.bashrc" | grep -E "export" | while read -r env; do
      name="$(echo "$env" | sed 's/=/ /' | awk '{print $2}')"
      value="$(echo "$env" | sed "s/export .*=//")"
      YES="$YES" viro env set "$name" "$value" \
        && sed -i "/export $name/d" "$HOME/.bashrc"
    done
    ;;
  edit) "$VISUAL" "$VIRO_ENV" && refresh;;
  choose) viro env | choose "viro env";;
  *) printenv \
      | sed -e 's/export //' -e 's/=/~/' -e "s/['\"]//g" \
      | grep -vE "^_" \
      | grep -v "PATH" \
      | column -t -s~
      ;;
esac
