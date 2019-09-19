source "${0%/*}/../src/normalize.sh";

is_installed() {
  case "$OS" in
    WSL) dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -c "ok installed" >/dev/null;;
    *) echo "[BIN] is_installed: $OS is not yet supported";;
  esac
}

ensure() {
  case "$OS" in
    WSL) is_installed "$1" || (echo "[INFO] installing: $1" && sudo apt install -y "$1");;
    *) echo "[BIN] ensure: $OS is not yet supported";;
  esac

}

repo() {
  case "$OS" in
    WSL)
      echo "[INFO] adding the $1 repository and updating"
      ensure software-properties-common \
        && sudo add-apt-repository "$1" -y \
        && sudo apt-get update
      ;;
    *) echo "[BIN] repo: $OS is not supported";;
  esac
}

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
