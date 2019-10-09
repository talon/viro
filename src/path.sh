source "$VIRO_HOME/src/utils.sh"

VIRO_USER="${VIRO_USER:-$VIRO_HOME/user}"
VIRO_PATH="${VIRO_PATH:-$VIRO_USER/PATH}"

case "$1" in
  # import)
  #   grep -vE "(VIRO_HOME|PATH)" "$HOME/.bashrc" | grep -E "export" | while read -r env; do
  #     name="$(echo "$env" | sed 's/=/ /' | awk '{print $2}')"
  #     value="$(echo "$env" | sed "s/export .*=//")"
  #     viro env add "$name" "$value" "$([[ -n "$YES" ]] && echo "--yes")" \
  #       && sed -i "/export $name/d" "$HOME/.bashrc"
  #   done
  #   ;;

  edit) "$VISUAL" "$VIRO_PATH" && exec bash;;

  add)
    dirs="${*:2}"
    dirs="${dirs:-"$(prompt "viro path add")"}"
    [[ -z "$dirs" ]] && exit 1

    for dir in $dirs; do
      ! viro path has "$dir" && add_to_path="$add_to_path:\"$(realpath "$dir")\""
    done
    echo "PATH=$(viro path ls | awk '{print "\""$0"\""}' | tr '\n' ':' | sed 's/:$//')$add_to_path" > "$VIRO_PATH"
    exec bash
    ;;

  rm)
    dirs="${*:2}"
    dirs="${dirs:-"$(viro path ls | fzf --multi --reverse --prompt "viro path rm ")"}"
    [[ -z "$dirs" ]] && exit 1

    for dir in $dirs; do
      dir="$(realpath "$dir")"
      yorn "viro path rm $dir" "$YES" \
        && PATH="${PATH//":$dir:"/":"}" \
        && PATH="${PATH/#"$dir:"}" \
        && PATH="${PATH/%":$dir"}"
    done

    echo "PATH=$(viro path ls | awk '{print "\""$0"\""}' | tr '\n' ':' | sed 's/:$//')" > "$VIRO_PATH"
    exec bash
    ;;

  has) viro path ls | grep -wq "${@:2}";;

  ls) echo "$PATH" | tr ":" "\n" | awk '!x[$0]++';;
esac
