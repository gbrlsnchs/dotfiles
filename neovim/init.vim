" I need to reset environment variables in order to pass them down to terminal
" emulators, otherwise the external variable would precede the one set here.
unlet $MANPAGER
let $MANPAGER = "nvr -cc tabnew --remote-wait +'Man! | setlocal bufhidden=wipe'"

unlet $GIT_EDITOR
let $GIT_EDITOR = "nvr -cc tabnew --remote-wait +'setlocal bufhidden=wipe'"

unlet $VISUAL
let $VISUAL = "nvr -cc split --remote-wait +'setlocal bufhidden=wipe'"

unlet $PAGER
let $PAGER = "nvr -cc tabnew --remote-wait +'Man! | setlocal bufhidden=wipe' -"

unlet $GIT_PAGER
let $GIT_PAGER = "nvr -cc tabnew --remote-wait +'Man! | setlocal bufhidden=wipe | setfiletype git' -"

lua require('init')

autocmd TermOpen * setlocal nospell
