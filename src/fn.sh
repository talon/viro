. "$VIRO_HOME/src/utils.sh"

VIRO_FN="${VIRO_FN:-$VIRO_USER/functions}"

new_fn() {
read -r -d '' VIRO_FN_TEMPLATE <<TEMPLATE
$name() { echo "try: viro fn edit $name"; }
TEMPLATE

echo "$VIRO_FN_TEMPLATE"
}

[ -e "$VIRO_FN" ] || mkdir -p "$VIRO_FN"
case "$1" in
  new)
    name="${2:-"$(prompt "viro fn new")"}"
    [ -z "$name" ] && return 1
    ! [ -f "$VIRO_FN/$name.sh" ] && new_fn "$name" > "$VIRO_FN/$name.sh" \
      && "$VISUAL" "$VIRO_FN/$name.sh" \
      && . "$VIRO_FN/$name.sh" \
      && return 0
    if [ -f "$VIRO_FN/$name.sh" ] && yorn "Already exists. viro fn edit $name?" "$YES"; then
      viro fn edit "$name" && return 0
    else
      return 1
    fi
    . "$VIRO_FN/$name.sh"
    ;;

  cp)
    old="${2:-$(
      fd . "$VIRO_FN" --type file --exec basename {} | fzf \
        --ansi \
        --layout reverse \
        --preview-window 'right:99%' \
        --preview  "bat --theme base16 --style snip --color always --language sh $VIRO_FN/{}"
    )}"
    new="${3:-"$(prompt "cp $old")"}"

    [ -f "$VIRO_FN/$new" ] && if yorn "Already exists. overwrite $new?" "$YES"; then
      cp "$VIRO_FN/$old" "$VIRO_FN/$new"
      . "$VIRO_FN/$new"
    else
      return 1
    fi
    ;;

  edit)
    if [ -n "$2" ] && [ -f "$VIRO_FN/$2.sh" ] || yorn "Not found. viro bin new $2?" "$YES"; then
      "$VISUAL" "$VIRO_FN/$2.sh"
    else
      viro bin new "$2"
    fi
    . "$VIRO_FN/$2.sh"
    ;;

  rm)
    names="${@:2}"
    names="${names:-"$(
      fd . "$VIRO_FN" --type file --exec basename {.} | fzf \
        --multi \
        --ansi \
        --layout reverse \
        --preview-window 'right:99%' \
        --preview  "bat --theme base16 --style snip --color always --language sh $VIRO_FN/{}.sh"
    )"}"
    [ -z "$names" ] && return 1
    for name in $names; do
      [ -f "$VIRO_FN/$name.sh" ] && yorn "remove $name?" "$YES" && rm "$VIRO_FN/$name.sh" && eval "unset -f $name"
    done
    ;;

  *)
    name="$(fd . "$VIRO_FN" --type file --exec basename {.} | fzf \
      --ansi \
      --layout reverse \
      --preview-window 'right:99%' \
      --preview  "bat --theme base16 --style snip --color always --language sh $VIRO_FN/{}.sh"
    )"
    "$VISUAL" "$VIRO_FN/$name.sh" && . "$VIRO_FN/$name.sh"
    ;;
esac
