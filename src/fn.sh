. "$VIRO_SRC/utils.sh"

VIRO_FN="${VIRO_FN:-$VIRO_USER/functions}"

new_fn() {
read -r -d '' VIRO_FN_TEMPLATE <<TEMPLATE
$name() { echo "try: viro fn edit $name"; }
TEMPLATE

echo "$VIRO_FN_TEMPLATE"
}

case "$1" in
  new)
    name=""
    [ -n "$2" ]    && name="$2" && shift
    [ -z "$name" ] && name="$(prompt "viro fn new")"
    [ -z "$name" ] && return 1
    [ -e "$VIRO_FN" ] || mkdir -p "$VIRO_FN"

    if ! [ -f "$VIRO_FN/$name.sh" ]; then
      new_fn "$name" > "$VIRO_FN/$name.sh"
      "$VISUAL" "$VIRO_FN/$name.sh"
      . "$VIRO_FN/$name.sh"
      return 0
    fi

    if yorn "Already exists. viro fn edit $name?" "$YORN"; then
      viro fn edit "$name" && return 0
    else
      return 1
    fi
    ;;

  cp)
    old=""
    [ -n "$2" ]   && old="$2" && shift
    [ -z "$old" ] && old="$(
      viro fn ls | fzf \
        --ansi \
        --prompt "viro fn cp " \
        --layout reverse \
        --preview-window 'right:99%' \
        --preview  "bat --theme base16 --style snip --color always --language sh $VIRO_FN/{}"
    )"
    [ -z "$old" ] && return 1

    new=""
    [ -n "$2" ]   && new="$2" && shift
    [ -z "$new" ] && new="$(prompt "viro fn cp $old")"
    [ -z "$new" ] && return 1

    if ! [ -f "$VIRO_FN/$new.sh" ] || yorn "Already exists. overwrite $new?" "$YORN"; then
      cp "$VIRO_FN/$old.sh" "$VIRO_FN/$new.sh"
      . "$VIRO_FN/$new.sh"
    else
      return 1
    fi
    ;;

  edit)
    name=""
    [ -n "$2" ]    && name="$2" && shift
    [ -z "$name" ] && name="$(viro fn ls | fzf \
      --ansi \
      --prompt "viro fn edit " \
      --layout reverse \
      --preview-window 'right:99%' \
      --preview  "bat --theme base16 --style snip --color always --language sh $VIRO_FN/{}.sh"
    )"
    [ -z "$name" ] && return 1
    [ -f "$VIRO_FN/$name.sh" ] && "$VISUAL" "$VIRO_FN/$name.sh"
    if ! [ -f "$VIRO_FN/$name.sh" ] && yorn "Not found. viro fn new $name?" "$YORN"; then
      viro fn new "$name" && return 0
    fi
    . "$VIRO_FN/$name.sh"
    ;;
  rm)
    names=""
    while [ -n "$2" ]; do
      name="$2"
      names="$([ -n "$names" ] && echo "$names $2" || echo "$2")" && shift
    done
    [ -z "$names" ] && names="$(
      viro fn ls | fzf \
        --multi \
        --prompt "viro fn rm " \
        --ansi \
        --layout reverse \
        --preview-window 'right:99%' \
        --preview  "bat --theme base16 --style snip --color always --language sh $VIRO_FN/{}.sh"
    )"
    [ -z "$names" ] && return 1

    for name in $names; do
      [ -f "$VIRO_FN/$name.sh" ] && yorn "remove $name?" "$YORN" && rm "$VIRO_FN/$name.sh" && eval "unset -f $name"
    done
    ;;

  ls)
    [ -e "$VIRO_FN" ] && find "$VIRO_FN" -name "*.sh" -exec basename {} .sh ';'
    ;;

  *) viro fn edit "$@";;
esac
