let g:lsc_enable_autocomplete = v:false
let g:lsc_auto_map = {
      \ 'defaults': v:true,
      \ 'Completion': 'omnifunc',
      \ 'ShowHover': 'gK',
      \ 'NextReference': '<Leader><C-n>',
      \ 'PreviousReference': '<Leader><C-p>',
      \}

hi! link lscDiagnosticWarning WarningMsg

" Servers
let s:srvs = {}

if executable('bash-language-server')
  let s:srvs['sh'] = 'bash-language-server start'
endif

if executable('gopls')
  let s:srvs['go'] = 'gopls'
endif

if executable('rnix-lsp')
  let s:srvs['go'] = 'rnix-lsp'
endif

if executable('rust-analyzer')
  let s:srvs['rust'] = 'rust-analyzer'
endif

if executable('terraform-ls')
  let s:srvs['terraform'] = 'terraform-ls serve'
endif

if executable('vim-language-server')
  let s:vimls = {
        \ 'name': 'vim-language-server',
        \ 'command': 'vim-language-server --stdio',
        \ 'message_hooks': {
        \   'initialize': {
        \     'initializationOptions': {
        \       'vimruntime': $VIMRUNTIME,
        \       'runtimepath': &runtimepath
        \     },
        \   },
        \ },
        \}
  let s:srvs['vim'] = s:vimls
endif


call map(s:srvs, {_,val -> type(val) == v:t_string ? { "command": val } : val})
call map(s:srvs, {_,val -> extend(val, {"suppress_stderr": v:true})})

let g:lsc_server_commands = s:srvs

function! s:init() abort
  if !get(g:, 'loaded_lsc', 0) | return | endif

  nnoremap <buffer> <F2> :LSClientAllDiagnostics<CR>

  autocmd VimEnter <buffer>
        \  if empty(filter(getqflist(), 'v:val.valid'))
        \|   exec 'LSClientAllDiagnostics' | q
        \| endif

  autocmd VimLeavePre <buffer> call lsc#server#disable() | delfunction lsc#server#exit

endfunction

augroup LSC_
  autocmd!
  exec 'autocmd FileType ' . join(keys(s:srvs), ',') . ' call s:init()'
augroup END
