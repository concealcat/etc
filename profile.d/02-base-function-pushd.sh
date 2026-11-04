DIRSTACK=""
pushd() {
  if [ -z "$1" ]; then
    echo "pushd: No diretory specified."
    return 1
  fi
  if [ ! -d "$1" ]; then
    echo "pushd: $1: No such directory."
    return 1
  fi
  DIRSTACK="$(pwd);$DIRSTACK"
  cd "$1" || return 1
}
popd() {
  if [ -z "$DIRSTACK" ]; then
    echo "popd: directory stack empty."
    return 1
  fi
  NEXTDIR="${DIRSTACK%%;*}"
  DIRSTACK="${DIRSTACK#*;}"
  cd "$NEXTDIR" || return 1
}

