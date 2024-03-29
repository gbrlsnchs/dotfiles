autoload -Uz +X compinit bashcompinit

# Custom functions.
fpath+=("$XDG_DATA_HOME/zsh/zfunc" "$ZDOTDIR/functions")
typeset -U fpath

for func in "$ZDOTDIR"/functions/* ; do
	autoload -Uz "$(basename $func)"
done
