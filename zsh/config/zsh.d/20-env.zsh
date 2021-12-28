# cargo
path+=("$HOME/.cargo/bin")

# go
path+=("$(go env GOPATH)/bin")

# python
path+=("$HOME/.poetry/bin")

# latex
path+=("/opt/texlive/2021/bin/$(uname --machine)-$(uname --kernel-name | tr '[:upper:]' '[:lower:]')")
