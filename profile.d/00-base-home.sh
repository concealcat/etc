HOME="${USRBIN}/home"
if [ -z "$USERNAME" ]; then
 HOME="$HOME/$USER"
else
 HOME="$HOME/$USERNAME"
fi
test ! -d "$HOME" && HOME="/"

