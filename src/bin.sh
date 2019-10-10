. "$VIRO_HOME/src/utils.sh"

VIRO_BIN="${VIRO_BIN:-$VIRO_USER/bins}"

read -r -d '' VIRO_BIN_TEMPLATE <<TEMPLATE
#!/bin/bash

# FLAGS
# NOTE: Use \`shift [# args]\` for each flag
# ==============================================================================================
while (( "\$#" )); do case "\$1" in
  # --yes|-y) YES="y" && shift;;

  --) shift && break;;
  -*|--*) log "Error: Unsupported flag $1" >&2 && exit 1;;
  *) PARAMS="\${PARAMS:-""} \$1" && shift;;
esac; done && eval set -- "\$PARAMS"

echo "This bin has no functionality yet. try: bin $( basename "${BASH_SOURCE[0]}" )"
TEMPLATE

[ -e "$VIRO_BIN" ] || mkdir -p "$VIRO_BIN"
case "$1" in
  new)
    name="${2:-"$(prompt "viro bin new")"}"
    [ -z "$name" ] && exit 1
    [ -f "$VIRO_BIN/$name" ] && if yorn "Already exists. viro bin edit $name?" "$YES"; then
      viro bin edit "$name" && exit 0
    else
      exit 1
    fi

    echo "$VIRO_BIN_TEMPLATE" > "$VIRO_BIN/$name" && chmod +x "$VIRO_BIN/$name"
    ;;

  cp)
    old="${2:-$(
      fd . "$VIRO_BIN" --type file --exec basename {} | fzf \
        --ansi \
        --layout reverse \
        --preview-window 'right:99%' \
        --preview  "bat --theme base16 --style snip --color always --language sh $VIRO_BIN/{}"
    )}"
    new="${3:-"$(prompt "cp $old")"}"

    [ -f "$VIRO_BIN/$new" ] && if yorn "Already exists. overwrite $new?" "$YES"; then
      cp "$VIRO_BIN/$old" "$VIRO_BIN/$new"
    else
      exit 1
    fi
    ;;

  rm)
    names="${@:2}"
    names="${names:-"$(
      fd . "$VIRO_BIN" --type file --exec basename {} | fzf \
        --multi \
        --ansi \
        --layout reverse \
        --preview-window 'right:99%' \
        --preview  "bat --theme base16 --style snip --color always --language sh $VIRO_BIN/{}"
    )"}"
    [ -z "$names" ] && exit 1
    for name in $names; do
      [ -f "$VIRO_BIN/$name" ] && yorn "remove $name?" "$YES" && rm "$VIRO_BIN/$name"
    done
    ;;

  edit)
    if [ -n "$2" ] && [ -f "$VIRO_BIN/$2" ] || yorn "Not found. viro bin new $2?" "$YES"; then
      "$VISUAL" "$VIRO_BIN/$2" && exit 0
    else
      viro bin new "$2"
    fi
    ;;

  *)
    fd . "$VIRO_BIN" --type file --exec basename {} | fzf \
      --ansi \
      --layout reverse \
      --preview-window 'right:99%' \
      --preview  "bat --theme base16 --style snip --color always --language sh $VIRO_BIN/{}" \
      --bind "enter:execute($VISUAL $VIRO_BIN/{})+cancel"
    ;;
esac
