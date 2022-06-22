_git_branch() {
	local branch_name=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
	if [[ "$branch_name" != "" ]]; then
		echo "【${branch_name}枝】"
	fi
}

PROMPT='%F{$color12}%B%n@%m%b%f %F{$color6}%B%~%b%f %F{$color7}$(_git_branch)%f 
%F{$color8}%B>>>%b%f '
RPROMPT='%(1j.jobs: %j, .)%(0?.%F{$color10}OK.%F{$color9}ERR [%?])%f'
