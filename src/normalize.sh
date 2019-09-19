use() { source "${0%/*}/src/$1.sh"; }

case "$(uname -a)" in
  Darwin*) OS="Darwin";;
  Linux*)
    OS="Linux"
    grep -q Microsoft /proc/version \
      && OS="WSL"
    ;;
esac

case "$OS" in
  WSL)
    BROWSER="/c/Program Files (x86)/Google/Chrome/Application/chrome.exe"
    CLIPBOARD="clip.exe"
    ;;
  Darwin)
    # on MacOS `open` uses the default browser
    BROWSER="open"
    CLIPBOARD="pbcopy"
    ;;
esac

clip() {
  [[ -z "$CLIPBOARD" ]] && { echo "no \$CLIPBOARD available"; exit 1; }
  "$CLIPBOARD"
}

open_url() {
  [[ -z "$BROWSER" ]] && { echo "no \$BROWSER available"; exit 1; }
  "$BROWSER" "$1"
}

