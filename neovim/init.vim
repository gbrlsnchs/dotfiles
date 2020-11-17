let $GIT_EDITOR = "nvr -cc tabnew --remote-wait +'setlocal bufhidden=wipe'"
let $VISUAL = "nvr -cc split --remote-wait +'setlocal bufhidden=wipe'"

syntax on

lua require('init')

autocmd TermOpen * setlocal nospell
