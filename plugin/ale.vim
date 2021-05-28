if &diff
  finish
endif

set omnifunc=ale#completion#OmniFunc

let g:ale_linters = {
      \ 'go': ['gofmt', 'golint', 'govet', 'gopls', 'golangci-lint'],
      \ 'rust': ['analyzer'],
      \}

let g:ale_fixers = {
      \ '*': ['remove_trailing_lines', 'trim_whitespace'],
      \ 'go': ['goimports'],
      \ 'json': ['prettier'],
      \ 'markdown': ['prettier'],
      \ 'nix': ['nixpkgs-fmt'],
      \ 'rust': ['rustfmt'],
      \ 'sh': ['shfmt'],
      \ 'terraform': ['terraform'],
      \}

" let g:ale_disable_lsp = 1
let g:ale_fix_on_save = 1

" Go configuration
let g:ale_go_golangci_lint_options = ''
let g:ale_go_golangci_lint_package = 1

" Rust configuration
let g:ale_rust_rustfmt_options = '--edition 2018'
let g:ale_rust_analyzer_config = {
      \ 'diagnostics': { 'disabled': ['unresolved-import'] },
      \ 'cargo': { 'loadOutDirsFromCheck': v:true },
      \ 'procMacro': { 'enable': v:true },
      \ 'checkOnSave': { 'command': 'clippy', 'enable': v:true },
      \ }

" Terraform configuration
let g:ale_terraform_langserver_executable = 'terraform-ls'
