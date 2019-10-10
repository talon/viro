export VIRO_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && cd ../ >/dev/null 2>&1 && pwd)"
MANPATH="$MANPATH:$VIRO_HOME"

export VIRO_USER="${VIRO_USER:-$HOME/.viro}"

for SOURCE in "$VIRO_USER/ENV" "$VIRO_USER/PATH" $VIRO_USER/functions/*; do
  [ -f "$SOURCE" ] && . "$SOURCE"
done

. "$VIRO_HOME/src/utils.sh"

viro() {
  YES=""
  PARAMS=""
  while (( "$#" )); do case "$1" in
    -h|--help) man viro && return 0;;
    --yes|-y|--force|-f) YES="y" && shift;;

    --) shift && break;;
    -*|--*) echo "Error: Unsupported flag $1" >&2 && return 1;;
    *) PARAMS="$PARAMS $1" && shift;;
  esac; done
  eval set -- "$PARAMS"

  case "$1" in
    install)
      PROFILE="$(
        if [ -f "$HOME/.bash_profile" ]; then
        echo "$HOME/.bash_profile"
      else
        echo "$HOME/.profile"
      fi)"
      [ -n "$YES" ] || {
        echo "two lines will be added to $PROFILE:"
        echo "   at the top: the path to your viro installation will be exported as \$VIRO_HOME"
        echo "   at the bottom: viro core will be sourced"
      }
      if [ -n "$YES" ] || yorn "Continue?"; then
        [ -f "$PROFILE" ] && sed -i '/VIRO_HOME/d' "$PROFILE"
        echo ". \"\$VIRO_HOME/src/apply.sh\"" >> "$PROFILE"
        sed -i "1i export VIRO_HOME=\"$VIRO_HOME\"" "$PROFILE"
        . "$PROFILE"
      else
        echo "Maybe make a backup first?"
        echo "try: mv $PROFILE $PROFILE.bak"
      fi
      ;;
    *)
      [ -f "$VIRO_HOME/src/$1.sh" ] \
        && YES="$YES" . "$VIRO_HOME/src/$1.sh" "${@:2}"
      ;;
  esac
}
