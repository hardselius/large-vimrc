if (exists('g:loaded_my_lsp_config') && g:loaded_my_lsp_config)
   finish
 endif
let g:loaded_my_lsp_config=1

" ALE

let g:ale_disable_lsp      = 1
let g:ale_echo_msg_format  = '[%linter%]: %s'
let g:ale_set_quickfix     = 1
let g:ale_set_signs        = 0

hi! link ALEError   Error
hi! link ALEWarning WarningMsg

nnoremap <F2> :ALEToggle<CR>

augroup LSP_ALE
    autocmd!
    autocmd User lsp_buffer_enabled
          \  call lsp#ale#enable()
          \| let b:ale_linters = get(b:, "ale_linters", []) + [ 'vim-lsp' ]
          \| ALELint

    let g:lsp_ale_diagnostics_severity = 'information'
    let g:lsp_ale_auto_enable_linter   = 0
augroup END

" vim-lsp

let g:lsp_diagnostics_highlights_enabled     = 1
let g:lsp_diagnostics_highlights_delay       = 0
let g:lsp_diagnostics_signs_enabled          = 0
let g:lsp_document_code_action_signs_enabled = 0

function! s:lsp_highlight() abort
  highlight link LspErrorHighlight   Error
  highlight link LspWarningHighlight WarningMsg
endfunction

function! s:lsp_init() abort
  setlocal omnifunc=lsp#complete
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

  nmap <buffer> ga <Plug>(lsp-code-action)
  nmap <buffer> gd <Plug>(lsp-definition)
  nmap <buffer> gs <Plug>(lsp-document-symbol-search)
  nmap <buffer> gS <Plug>(lsp-workspace-symbol-search)
  nmap <buffer> gr <Plug>(lsp-references)
  nmap <buffer> gi <Plug>(lsp-implementation)
  nmap <buffer> <leader>gt <Plug>(lsp-type-definition)
  nmap <buffer> <leader>R <Plug>(lsp-rename)
  nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
  nmap <buffer> <leader>k <Plug>(lsp-hover)
  inoremap <buffer> <expr><C-f> lsp#scroll(+4)
  inoremap <buffer> <expr><C-d> lsp#scroll(-4)
endfunction

let g:lsp_settings = {
      \  'rust-analyzer': #{
      \    initialization_options: #{
      \      completion: #{
      \        autoimport: #{ enable: v:true },
      \      },
      \      cargo: #{
      \        loadOutDirsFromCheck: v:true
      \      },
      \      checkOnSave: #{
      \        command: "clippy"
      \      },
      \      procMacro: #{
      \        enable: v:true
      \      },
      \    },
      \  },
      \}

augroup LSP
  autocmd!
  autocmd ColorScheme * call s:lsp_highlight()
  autocmd User lsp_buffer_enabled call s:lsp_init()
augroup END
