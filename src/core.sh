export VIRO_SRC="${VIRO_SRC:-"$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"}"
export VIRO_USER="${VIRO_USER:-$HOME/.viro}"

for SOURCE in "$VIRO_USER/ENV" "$VIRO_USER/PATH" $VIRO_USER/functions/*; do
  [ -f "$SOURCE" ] && . "$SOURCE"
done

. "$VIRO_SRC/utils.sh"

viro() {
  case "$1" in
    install)
      PROFILE="$(
        if [ -f "$HOME/.bash_profile" ]; then
          echo "$HOME/.bash_profile"
        else
          echo "$HOME/.profile"
        fi)"
      if [ -z "$YORN" ] || [ "$YORN" == "n" ]; then
        echo "two lines will be added to $PROFILE:"
        echo "   at the top: the path to your viro installation will be exported as \$VIRO_HOME"
        echo "   at the bottom: viro core will be sourced"
      fi
      if yorn "Continue?" "$YORN"; then
        [ -f "$PROFILE" ] && sed -i '/VIRO_SRC/d' "$PROFILE"
        echo ". \"\$VIRO_SRC/core.sh\"" >> "$PROFILE"
        sed -i "1i export VIRO_SRC=\"$VIRO_SRC\"" "$PROFILE"
        . "$PROFILE"
      else
        echo "Maybe make a backup first?"
        echo "try: mv $PROFILE $PROFILE.bak"
      fi
      ;;
    *)
      cmd="$1" && shift
      ! [ -f "$VIRO_SRC/$cmd.sh" ] && echo "unknown command" && return 1
      . "$VIRO_SRC/$cmd.sh" "$@"
      ;;
  esac
}
