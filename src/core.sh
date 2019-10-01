export PATH="$PATH:$VIRO_HOME"
export MANPATH="$MANPATH:$VIRO_HOME/man"

SOURCES="$VIRO_HOME/user/ENV"
SOURCES="$SOURCES $VIRO_HOME/user/aliases"
SOURCES="$SOURCES $VIRO_HOME/user/PATH"
SOURCES="$SOURCES $VIRO_HOME/user/boot.sh"
for SOURCE in $SOURCES; do
  [[ -f "$SOURCE" ]] && source "$SOURCE"
done
