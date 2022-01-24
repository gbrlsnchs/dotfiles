# My personal dotfiles

I use [Park] in order to manage my dotfiles. It provides me a
very nice tree view of what's going on. Here's an example after initializing it:
```console
$ envsubst < park/configs.toml | park
.                     := /home/gbrlsnchs/dev/gitlab.com/gbrlsnchs/dotfiles
├── alacritty         <- /home/gbrlsnchs/.config/alacritty     (DONE)
├── bspwm             <- /home/gbrlsnchs/.config/bspwm         (DONE)
├── cargo
│   └── config.toml   <- /home/gbrlsnchs/.cargo/config.toml    (DONE)
├── dunst
│   └── config        <- /home/gbrlsnchs/.config/dunst         (DONE)
├── fontconfig        <- /home/gbrlsnchs/.config/fontconfig    (DONE)
├── git               <- /home/gbrlsnchs/.config/git           (DONE)
├── latex
│   └── latexmkrc     <- /home/gbrlsnchs/.latexmkrc            (DONE)
├── neovim
│   └── config        <- /home/gbrlsnchs/.config/nvim          (DONE)
├── picom             <- /home/gbrlsnchs/.config/picom         (DONE)
├── polybar           <- /home/gbrlsnchs/.config/polybar       (DONE)
├── ssh
│   └── config        <- /home/gbrlsnchs/.ssh/config           (DONE)
├── sxhkd             <- /home/gbrlsnchs/.config/sxhkd         (DONE)
├── xorg
│   ├── xinitrc       <- /home/gbrlsnchs/.xinitrc              (DONE)
│   └── xserverrc     <- /home/gbrlsnchs/.xserverrc            (DONE)
└── zsh
    ├── config
    │   ├── functions <- /home/gbrlsnchs/.config/zsh/functions (DONE)
    │   ├── zsh.d     <- /home/gbrlsnchs/.config/zsh.d         (DONE)
    │   └── zshrc     <- /home/gbrlsnchs/.config/zsh/.zshrc    (DONE)
    ├── data          <- /home/gbrlsnchs/.local/share/zsh      (DONE)
    └── zshenv        <- /home/gbrlsnchs/.zshenv               (DONE)
```

## Features
- Handcrafted Neovim stuff, no additional package manager involved
- ZSH with custom prompt and _without_ Oh-My-Zsh
- Homemade way of generating config files based on my own color palette by using a script and [Park]
- Modular management thanks to [Park]

## Initializing
```console
$ ./contrib/init
```

[Park]: https://github.com/gbrlsnchs/park
