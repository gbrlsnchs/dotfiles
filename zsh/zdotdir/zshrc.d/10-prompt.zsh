_git_branch() {
	local branch_name=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
	if [[ $branch_name != '' ]]; then
		echo " ($branch_name)"
	fi
}

PROMPT='%F{$color6}%B%d%b%f%F{$color8}$(_git_branch)%f
%F{$color8}%B>%b%f '
RPROMPT='%(1j.jobs: %j, .)%(0?.%F{$color10}OK.%F{$color9}ERR [%?])%f'
