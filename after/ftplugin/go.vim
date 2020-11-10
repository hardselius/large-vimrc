set shiftwidth=4 tabstop=4 softtabstop=4 noexpandtab autoindent smartindent

setlocal path=.,**,$GOPATH/src
setlocal include=^\\s*import\\s*[\"']\\zs[^\"']*

let g:ale_linters = {'go': ['gofmt', 'golint', 'govet', 'gopls', 'golangci-lint']}
let g:ale_go_golangci_lint_package = 1
let g:ale_go_golangci_lint_options = ''
setlocal omnifunc=ale#completion#OmniFunc
compiler go

