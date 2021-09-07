" servers

let s:servers = {}

let s:servers["Bash Language Server"] = #{
      \   cmd: [ "bash-language-server", "start" ],
      \   ft: [ "sh" ],
      \ }

let s:servers["Dhall Language Server"] = #{
      \   cmd: [ "dhall-lsp-server" ],
      \   ft: [ "dhall" ],
      \ }

let s:servers["gopls"] = #{
      \   cmd: [ "gopls", "serve" ],
      \   log_level: -1,
      \   ft: [ "go" ],
      \ }

let s:servers["rnix-lsp"] = #{
      \   cmd: [ "rnix-lsp" ],
      \   ft: [ "nix" ],
      \ }

let s:servers["rust-analyzer"] = #{
      \   cmd: [ "rust-analyzer" ],
      \   ft: [ "rust" ]
      \ }

let s:servers["TypeScript Language Server"] = #{
      \   cmd: [ "typescript-langugage-server", "--stdio" ],
      \   ft: [ "javascript", "typescript" ],
      \ }

let s:servers["Terraform Language Server"] = #{
      \   cmd: [ "terraform-ls", "serve" ],
      \   ft: [ "terraform" ]
      \ }

let s:servers["VimScript Langugage Server"] = #{
      \   cmd: [ 'vim-language-server', "--stdio" ],
      \   init: #{
      \     options: #{
      \       vimruntime: $VIMRUNTIME,
      \       runtimepath: &runtimepath,
      \     }
      \   },
      \   ft: [ "vim" ],
      \ }

" helpers

function! s:register() abort
  for [ name, serv ] in items(s:servers)
    if executable(serv.cmd[0])
      call s:reg(name, serv)
    endif
  endfor
endfunction

" vim-lsc

let g:lsc_enable_autocomplete = v:false
let g:lsc_hover_popup = v:false
let g:lsc_reference_highlights = v:false
let g:lsc_auto_map = {
      \   "defaults": v:true,
      \   "Completion": "omnifunc",
      \   "ShowHover": "gK",
      \   "NextReference": "<Leader><C-n>",
      \   "PreviousReference": "<Leader><C-p>",
      \ }

function! s:lsc_register() abort
  function! s:reg(name, svr) abort
    let server = {}
    let server.name = a:name
    let server.command = join(a:svr.cmd, " ")

    if has_key(a:svr, "init")
      let server.message_hooks = {}
      let server.message_hooks.initialize = {}

      if has_key(a:svr.init, "root")
        let server.message_hooks.initialize.rootUri = a:svr.init.root.lsc
      endif

      if has_key(a:svr.init, "options")
        let server.message_hooks.initialize.initializationOptions = a:svr.init.options
      endif
    endif

    if has_key(a:svr, "workspace")
      let server.workspace_config = a:svr.workspace
    endif

    if has_key(a:svr, "log_level")
      let server.log_level = a:svr.log_level
    endif

    let server.suppress_stderr = v:true

    for ft in a:svr.ft
      let g:lsc_server_commands[ft] = server
    endfor
  endfunction

  let g:lsc_server_commands = {}
  call s:register()
endfunction

call s:lsc_register()

function! s:lsc_init() abort
  if !get(g:, 'loaded_lsc', 0) | return | endif

  nnoremap <buffer> <F2> :LSClientAllDiagnostics<CR>

  autocmd VimEnter <buffer>
        \  if empty(filter(getqflist(), 'v:val.valid'))
        \|   exec 'LSClientAllDiagnostics' | q
        \| endif

  " autocmd VimLeavePre <buffer> call lsc#server#disable() | delfunction lsc#server#exit

endfunction

function! s:lsc_highlight() abort
  highlight link lscDiagnosticError Error
  highlight link lscDiagnosticWarning SpellBad
  highlight link lscDiagnosticInfo SpellCap
  highlight link lscDiagnosticHint SpellCap
  highlight link lscReference CursorColumn
  highlight link lscCurrentParameter CursorColumn
endfunction

augroup LSC_
  autocmd!
  exec "autocmd FileType " . join(keys(g:lsc_server_commands), ",") . " call s:lsc_init()"
  autocmd ColorScheme * call s:lsc_highlight()
augroup END
