if &diff
  finish
endif

let g:ale_linters = {
      \ 'go': ['gofmt', 'golint', 'govet', 'gopls', 'golangci-lint'],
      \ 'rust': ['analyzer'],
      \}

let g:ale_fixers = {
      \ 'nix': ['nixpkgs-fmt'],
      \ 'rust': ['rustfmt'],
      \ 'terraform': ['terraform'],
      \}

let g:ale_fix_on_save = 1
let g:ale_go_golangci_lint_options = ''
let g:ale_go_golangci_lint_package = 1
let g:ale_terraform_langserver_executable = 'terraform-ls'

set omnifunc=ale#completion#OmniFunc
