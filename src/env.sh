. "$VIRO_SRC/utils.sh"

VIRO_ENV="${VIRO_ENV:-$VIRO_USER/ENV}"

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
    name=""
    [ -n "$2" ]    && name="$2" && shift
    [ -z "$name" ] && name="$(viro env ls | fzf --reverse --prompt "viro env set " | awk '{print $1}')"
    [ -z "$name" ] && return 1
    name="$(echo "$name" | tr '[:lower:]' '[:upper:]')"
    viro env has "$name" && ! yorn "replace $name?" "$YORN" && return 1

    value=""
    [ -n "$2" ]     && value="$2" && shift
    [ -z "$value" ] && value="$(prompt "viro env set $name")"
    [ -z "$value" ] && return 1

    [ -e "$(dirname "$VIRO_ENV")" ] || mkdir -p "$(dirname "$VIRO_ENV")" && touch "$VIRO_ENV"

    sed -i "/export $name=/d" "$VIRO_ENV"
    echo "export $name=\"$value\"" >> "$VIRO_ENV"
    . "$VIRO_ENV"
    echo "$value"
    ;;

  get)
    name=""
    [ -n "$2" ]    && name="$2" && shift
    [ -z "$name" ] && name="$(viro env ls | fzf --reverse --prompt "viro env set " | awk '{print $1}')"
    [ -z "$name" ] && return 1
    name="$(echo "$name" | tr '[:lower:]' '[:upper:]')"

    value="$(printenv "$name")"

    if [ -n "$value" ]; then
      echo "$value"
    else
      viro env set "$name" "$3"
    fi
    ;;

  rm)
    names=""
    while [ -n "$2" ]; do
      name="$(echo "$2" | tr '[:lower:]' '[:upper:]')"
      viro env has "$name" && names="$names $2" && shift
    done

    [ -z "$names" ] && names="$(
      sed -e 's/export //' -e 's/=/~/' -e "s/['\"]//g" < "$VIRO_ENV" \
        | column -t -s~ \
        | fzf --multi --reverse --prompt "viro env rm " \
        | awk '{print $1}'
    )"

    [ -z "$names" ] && return 1

    for name in $names; do
      name="$(echo "$name" | tr '[:lower:]' '[:upper:]')"
      if yorn "viro env rm $name?" "$YORN"; then
        sed -i "/export $name=/d" "$VIRO_ENV"
      fi
      eval "unset $name"
    done
    ;;

  has) [ -n "$(printenv "$2")" ];;


  ls) printenv \
      | sed -e 's/export //' -e 's/=/|/' -e "s/['\"]//g" \
      | grep -vE "^_" \
      | grep -v "PATH" \
      | column -t -s\|
      ;;

  *) viro env set "$2";;
esac
