export PATH="$PATH:$VIRO_HOME"
MANPATH="$MANPATH:$VIRO_HOME"

export VIRO_USER="${VIRO_USER:-$HOME/.viro}"

for SOURCE in "$VIRO_USER/ENV" "$VIRO_USER/PATH" $VIRO_USER/functions/*; do
  [ -f "$SOURCE" ] && . "$SOURCE"
done

