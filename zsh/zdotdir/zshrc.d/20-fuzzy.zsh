export FZF_DEFAULT_COMMAND="fd --type file --hidden --no-ignore-vcs"

for file in /usr/share/fzf/*.zsh ; do
	source $file
done

load_plugin fzf-tab

zstyle ':fzf-tab:*' fzf-flags \
    --color fg:"$foreground",bg:"$background",hl:"$color11" \
	--color fg+:"$foreground",bg+:"$background",hl+:"$color3" \
    --color info:"$foreground",prompt:"$color2",pointer:"$foreground" \
	--color spinner:"$foreground",marker:"$foreground"
