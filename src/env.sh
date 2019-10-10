source "$VIRO_HOME/src/utils.sh"

VIRO_ENV="${VIRO_ENV:-$VIRO_USER/ENV}"

[ -e "$(dirname "$VIRO_ENV")" ] && mkdir -p "$(dirname "$VIRO_ENV")"
case "$1" in
  # import)
  #   rc="${2:-$HOME/.bashrc}"
  #   echo "$rc"
  #   grep -vE "(VIRO_HOME|PATH)" "$rc" | grep -E "export" | while read -r env; do
  #     name="$(echo "$env" | sed 's/=/ /' | awk '{print $2}')"
  #     value="$(echo "$env" | sed "s/export .*=//")"
  #     echo "$name"
  #   done
  #   ;;

  set)
    name="$2"
    name="${name:-"$(viro env ls | fzf --reverse --prompt "viro env set " | awk '{print $1}')"}"
    [ -n "$2" ] && [ -n "$name" ] && \
      viro env has "${name^^}" && ! yorn "replace ${name^^}?" "$YES" && exit 1
    value="${*:3}"
    value="${value:-"$(prompt "viro env set ${name^^}")"}"
    [ -z "$value" ] && exit 1

    [ -f "$VIRO_ENV" ] && sed -i "/export ${name^^}=/d" "$VIRO_ENV"
    echo "export ${name^^}=\"$value\"" >> "$VIRO_ENV"
    exec bash
    ;;

  get)
    name="${2:-"$(viro env ls | fzf --reverse --prompt "viro env get" | awk '{print $1}')"}"
    value="$(printenv "${name^^}")"
    if [ -n "$value" ]; then
      echo "$value"
    else
      viro env set "$name" "$3"
    fi
    ;;

  rm)
    names="${*:2}"
    names="${names:-"$(
      sed -e 's/export //' -e 's/=/~/' -e "s/['\"]//g" < "$VIRO_ENV" \
        | column -t -s~ \
        | fzf --multi --reverse --prompt "viro env rm " \
        | awk '{print $1}'
    )"}"
    for name in $names; do
      name="${name^^}"
      if yorn "viro env rm $name?" "$YES"; then
        sed -i "/export $name=/d" "$VIRO_ENV"
      fi
    done
    exec bash
    ;;

  has) [ -n "$(printenv "$2")" ];;

  edit) "$VISUAL" "$VIRO_ENV" && exec bash;;

  ls) printenv \
      | sed -e 's/export //' -e 's/=/|/' -e "s/['\"]//g" \
      | grep -vE "^_" \
      | grep -v "PATH" \
      | column -t -s\|
      ;;
esac
