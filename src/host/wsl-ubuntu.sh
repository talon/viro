source "$VIRO_HOME/src/log.sh"

BROWSER="/c/Program Files (x86)/Google/Chrome/Application/chrome.exe"
CLIPBOARD="clip.exe"

clip() { "$CLIPBOARD"; }

open_url() { "$BROWSER" "$1"; }

is_installed() { dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -c "ok installed" >/dev/null; }

ensure() { is_installed "$1" || (log "installing: $1" && sudo apt install -y "$1"); }

repo() {
  log "adding the $1 repository and updating"
  ensure software-properties-common \
    && sudo add-apt-repository "$1" -y \
    && sudo apt update
}

clone() {
  [[ -e "$2" ]] || {
    log "cloning $1";
    mkdir -p "$(dirname "$2")";
    git clone "$1" "$2";
  }
}

download() {
  [[ -e "$2" ]] || {
    log "downloading $1 via curl";
    curl -fLo "$2" --create-dirs "$1"
  }
}
