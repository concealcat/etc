vim() { vim.exe -i NONE -c "set ambiwidth=double" "$@"; }
eliminate_viminfo() { rm ./_viminfo ~/_viminfo 2>/dev/null; }

