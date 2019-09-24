# will `echo` it's arguments prefixed with the [filename] that the log is from
log() { echo "[$( basename "${BASH_SOURCE[1]}" )]" "$@"; }
