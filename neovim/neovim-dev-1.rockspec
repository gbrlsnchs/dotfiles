package = "neovim"
version = "dev-1"
source = { url = "git+ssh://git@gitlab.com/gbrlsnchs/dotfiles.git" }
build = { type = "builtin" }
dependencies = {
	"lsqlite3 == 0.9.5-1",
	"lyaml == 6.2.7-1",
}
