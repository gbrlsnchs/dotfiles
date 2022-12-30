_git_branch() {
	local branch_name=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
	if [[ "$branch_name" != "" ]]; then
		echo "$(_sep) %F{#$COLOR_7}$(kana --katakana buranchi)%B${branch_name}%b%f"
	fi
}

_kak_session() {
	if [[ "$kak_session" != "" ]]; then
		echo "$(_sep) %F{#$COLOR_7}$(kana --katakana sesshon)%B${kak_session}%b%f"
	fi
}

_kana_hostname() {
	kana --katakana $(hostname) 2>/dev/null || echo "%m"
}

_sep() {
	echo "%F{#$COLOR_8}%B•%b%f"
}

PROMPT='%F{#$COLOR_12}%B%n%b%f%F $(_sep) %F{#$COLOR_13}%B$(_kana_hostname)%b%f $(_sep) %F{#$COLOR_14}%B%~%b%f $(_kak_session) $(_git_branch) 
%F{#$COLOR_11}%B>>>%b%f '
RPROMPT='%(1j.jobs: %j, .)%(0?.%F{#$COLOR_10}OK.%F{#$COLOR_9}ERR [%?])%f'
