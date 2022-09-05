_git_branch() {
	local branch_name=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
	if [[ "$branch_name" != "" ]]; then
		echo "【${branch_name}枝】"
	fi
}

_kana_hostname() {
	kana --katakana $(hostname) 2>/dev/null || echo "%m"
}

PROMPT='%F{#$COLOR_12}%B%n@$(_kana_hostname)%b%f %F{#$COLOR_6}%B%~%b%f %F{#$COLOR_7}$(_git_branch)%f 
%F{#$COLOR_8}%B>>>%b%f '
RPROMPT='%(1j.jobs: %j, .)%(0?.%F{#$COLOR_10}OK.%F{#$COLOR_9}ERR [%?])%f'
