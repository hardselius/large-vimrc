set shiftwidth=4
let &softtabstop = &shiftwidth
set noexpandtab
set autoindent
set smartindent

setlocal path=.,**,$GOPATH/src
setlocal include=^\\s*import\\s*[\"']\\zs[^\"']*

compiler go

