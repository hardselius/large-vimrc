if exists('g:loaded_my_lsc_config')
  finish
endif
let g:loaded_my_lsc_config=1

let g:lsc_server_commands = {}
let s:servers = {
      \   "ccls": #{
      \     command: "ccls",
      \     message_hooks: #{
      \       initialize: #{
      \         rootUri: {m, p -> lsc#uri#documentUri(fnamemodify(findfile("compile_commands.json", expand("%:p") . ";"), ":p:h"))},
      \         initializationOptions: #{
      \           cache: #{ directory: "/tmp/ccls/cache" },
      \           clang: #{ extraArgs: ["--gcc-toolchain=/usr"] },
      \         },
      \       },
      \     },
      \     ft: [ "c", "cpp", "objc", "objcpp" ],
      \   },
      \   "bash-language-server": #{
      \     command: "bash-language-server start",
      \     ft: [ "sh" ],
      \   },
      \   "gopls": #{
      \     command: "gopls serve",
      \     ft: [ "go" ],
      \     log_level: -1,
      \   },
      \   "rnix-lsp": #{
      \     command: "rnix-lsp",
      \     ft: [ "nix" ],
      \   },
      \   "rust-analyzer": #{
      \     command: "rust-analyzer",
      \     ft: [ "rust" ],
      \     message_hooks: #{
      \       initialize: #{
      \         initializationOptions: #{
      \           cargo: #{
      \             loadOutDirsFromCheck: v:true
      \           },
      \           checkOnSave: #{
      \             command: "clippy"
      \           },
      \           procMacro: #{
      \             enable: v:true
      \           },
      \         },
      \       },
      \     },
      \   },
      \   "typescript-language-server": #{
      \     command: "typescript-language-server --stdio",
      \     ft: [ "javascript", "typescript" ],
      \     log_level: -1,
      \   },
      \   "terraform-ls": #{
      \     command: "terraform-ls serve",
      \     ft: [ "terraform" ],
      \   },
      \   "vim-language-server": #{
      \     command: "vim-language-server --stdio",
      \     ft: [ "vim" ],
      \     message_hooks: #{
      \       initialize: #{
      \         initializationOptions: #{
      \           vimruntime: $VIMRUNTIME,
      \           runtimepath: &runtimepath,
      \         },
      \       },
      \     },
      \   },
      \   "jsonnet-language-server": #{
      \     command: "jsonnet-language-server",
      \     ft: [ "jsonnet" ],
      \   },
      \ }

for [ s:name, s:serv ] in items(s:servers)
  if executable(split(s:serv.command)[0])
    let server = s:serv
    let server.name = s:name
    let server.suppress_stderr = v:true
    for ft in remove(server, "ft")
      let g:lsc_server_commands[ft] = server
    endfor
  endif
endfor | unlet s:name s:serv s:servers

let g:lsc_enable_autocomplete = v:false
" let g:lsc_hover_popup = v:false
let g:lsc_reference_highlights = v:false
let g:lsc_auto_map = {
      \   "defaults": v:true,
      \   "Completion": "omnifunc",
      \   "ShowHover": "gK",
      \   "NextReference": "<Leader><C-n>",
      \   "PreviousReference": "<Leader><C-p>",
      \ }

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
  autocmd ColorScheme * call s:lsc_highlight()
  autocmd VimLeavePre <buffer> call lsc#server#disable() | delfunction lsc#server#exit
augroup END
