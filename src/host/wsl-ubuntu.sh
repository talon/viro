BROWSER="/c/Program Files (x86)/Google/Chrome/Application/chrome.exe"
CLIPBOARD="clip.exe"
DISTRO="$(lsb_release -id | head -n 1 | awk '{print $3}')"

clip() { "$CLIPBOARD"; }

open_url() { "$BROWSER" "$1"; }

is_installed() { dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -c "ok installed" >/dev/null; }

ensure() { is_installed "$1" || (echo "[INFO] installing: $1" && sudo apt install -y "$1"); }

repo() {
  echo "[INFO] adding the $1 repository and updating"
  ensure software-properties-common \
    && sudo add-apt-repository "$1" -y \
    && sudo apt-get update
}

# TODO: is envsubst always available in 18.04 Ubuntu? should we check that it's installed?
#       I only ask cause `ensure` doesn't work for it
template() {
  exists "$2" || {
    echo "[INFO] creating $2 from template $1";
    mkdir -p "$(dirname "$2")";
    envsubst > "$2" < "$1";
  }
}

clone() {
  exists "$2" || {
    echo "[INFO] cloning $1";
    mkdir -p "$(dirname "$2")";
    git clone "$1" "$2";
  }
}

download() {
  exists "$2" || {
    echo "[INFO] downloading $1 via curl";
    curl -fLo "$2" --create-dirs "$1"
  }
}
