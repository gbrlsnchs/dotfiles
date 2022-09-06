export FZF_DEFAULT_COMMAND="fd --color=always --type file --hidden --no-ignore-vcs"

if [[ ! -o login ]]; then
	export FZF_DEFAULT_OPTS="
		$FZF_DEFAULT_OPTS
		--ansi
		--color fg:#$FG_COLOR,bg:#$BG_COLOR,hl:#$COLOR_1
		--color fg+:#$FG_COLOR,bg+:#$BG_COLOR,hl+:#$COLOR_9
		--color info:#$FG_COLOR,prompt:#$COLOR_2,pointer:#$FG_COLOR
		--color spinner:#$FG_COLOR,marker:#$FG_COLOR
		"
fi

for file in /usr/share/fzf/*.zsh ; do
	source $file
done

load_plugin fzf-tab

if [[ ! -o login ]]; then
	zstyle ':fzf-tab:*' fzf-flags \
		--color "fg:#$FG_COLOR,bg:#$BG_COLOR,hl:#$COLOR_1" \
		--color "fg+:#$FG_COLOR,bg+:#$BG_COLOR,hl+:#$COLOR_9" \
		--color "info:#$FG_COLOR,prompt:#$COLOR_2,pointer:#$FG_COLOR" \
		--color "spinner:#$FG_COLOR,marker:#$FG_COLOR"
fi
