autoload -U +X bashcompinit && bashcompinit

# Completion for Terraform.
complete -o nospace -C /usr/bin/terraform terraform

# Completion for AWS CLI.
complete -C $(which aws_completer) aws

load_plugin zsh-completions
load_plugin zsh-autosuggestions
