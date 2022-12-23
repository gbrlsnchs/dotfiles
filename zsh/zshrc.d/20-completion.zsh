load_plugin zsh-completions

compinit
bashcompinit

# Completion for Terraform.
complete -o nospace -C /usr/bin/terraform terraform

# Completion for AWS CLI.
complete -C $(which aws_completer) aws
