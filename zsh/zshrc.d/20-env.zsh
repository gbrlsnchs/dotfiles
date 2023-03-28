path=("$XDG_BIN_HOME" $path)

# cargo
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
path+=("$CARGO_HOME/bin")

# go
path+=("$(go env GOPATH)/bin")
export GOPROXY=direct

# python
path+=("$HOME/.poetry/bin")

# latex
path+=("/opt/texlive/2021/bin/$(uname --machine)-$(uname --kernel-name | tr '[:upper:]' '[:lower:]')")

export SVDIR="$XDG_DATA_HOME/service"
export EDITOR="${EDITOR:-kak}"
export VISUAL="$EDITOR"
export GPG_TTY="$(tty)"
export MENUCONFIG_COLOR=mono
