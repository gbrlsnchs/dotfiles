path=("$XDG_BIN_HOME" $path)

# cargo
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
path+=("$CARGO_HOME/bin")

# node
export NEXT_TELEMETRY_DISABLED=1
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# go
path+=("$(go env GOPATH)/bin")
export GOPROXY=direct

# python
path+=("$HOME/.poetry/bin")

# latex
path+=("/opt/texlive/2021/bin/$(uname --machine)-$(uname --kernel-name | tr '[:upper:]' '[:lower:]')")

# ruby
path+=("$HOME/.rvm/bin")
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

export SVDIR="$XDG_DATA_HOME/service"
export EDITOR="${EDITOR:-kak}"
export VISUAL="$EDITOR"
export GPG_TTY="$(tty)"
export MENUCONFIG_COLOR=mono

function chpwd() {
	if [[ -f .env ]]; then
		set -o allexport; source .env; set +o allexport
	fi
}

typeset -U path
