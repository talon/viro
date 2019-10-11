. "$VIRO_SRC/utils.sh"

VIRO_PATH="${VIRO_PATH:-$VIRO_USER/PATH}"

case "$1" in
  # import)
  #   grep -vE "(VIRO_HOME|PATH)" "$HOME/.bashrc" | grep -E "export" | while read -r env; do
  #     name="$(echo "$env" | sed 's/=/ /' | awk '{print $2}')"
  #     value="$(echo "$env" | sed "s/export .*=//")"
  #     viro env add "$name" "$value" "$([ -n "$YORN" ] && echo "--yes")" \
  #       && sed -i "/export $name/d" "$HOME/.bashrc"
  #   done
  #   ;;

  add)
    add_to_path=""
    while [ -n "$2" ]; do
      dir="$2" && shift
      if ! viro path has "$dir"; then
        add_to_path="$add_to_path:\"$(realpath "$dir")\""
      fi
    done
    [ -z "$add_to_path" ] && add_to_path=":\"$(prompt "viro path add")\""
    [ -z "$add_to_path" ] && return 1
    echo "PATH=$(viro path ls | awk '{print "\""$0"\""}' | tr '\n' ':' | sed 's/:$//')$add_to_path" > "$VIRO_PATH"
    . "$VIRO_PATH"
    ;;

  rm)
    # dirs="${dirs:-"$(viro path ls | fzf --multi --reverse --prompt "viro path rm ")"}"
    while [ -n "$2" ]; do
      dir="$(realpath "$2")" && shift
      yorn "viro path rm $dir" "$YORN" \
        && PATH="${PATH//":$dir:"/":"}" \
        && PATH="${PATH/#"$dir:"}" \
        && PATH="${PATH/%":$dir"}"
    done

    echo "PATH=$(viro path ls | awk '{print "\""$0"\""}' | tr '\n' ':' | sed 's/:$//')" > "$VIRO_PATH"
    . "$VIRO_PATH"
    ;;

  has) viro path ls | grep -wq "${@:2}";;

  ls) echo "$PATH" | tr ":" "\n" | awk '!x[$0]++';;
esac
