path=("$XDG_BIN_HOME" $path)

# cargo
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
path=("$CARGO_HOME/bin" $path)

# node
export NEXT_TELEMETRY_DISABLED=1
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# go
path=("$(go env GOPATH)/bin" $path)
export GOPROXY=direct

# python
path=("$HOME/.poetry/bin" $path)

# latex
path=("/opt/texlive/2021/bin/$(uname --machine)-$(uname --kernel-name | tr '[:upper:]' '[:lower:]')" $path)

# ruby
path=("$HOME/.rvm/bin" $path)
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# emscripten
path=("$HOME/.emsdk" "$HOME/.emsdk/upstream/emscripten" $path)

export SVDIR="$XDG_DATA_HOME/service"
export EDITOR="${EDITOR:-kak}"
export VISUAL="$EDITOR"
export GPG_TTY="$(tty)"
export MENUCONFIG_COLOR=mono

typeset -U path
