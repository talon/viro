export PATH="$PATH:$VIRO_HOME"
export VIRO_USER="${VIRO_USER:-$VIRO_HOME/user}"

for SOURCE in "$VIRO_USER/ENV" "$VIRO_USER/PATH" $VIRO_USER/functions/*; do
  [[ -f "$SOURCE" ]] && source "$SOURCE"
done
