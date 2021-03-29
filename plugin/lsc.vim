" if &diff
"   finish
" endif

" let g:lsc_enable_autocomplete = v:false
let g:lsc_hover_popup = v:false

" let g:lsc_server_commands = { 
"       \ 'rust': {
"       \   'name': 'rust-analyzer',
"       \   'command': 'rust-analyzer-logged.sh',
"       \   'workspace_config': {
"       \     'rust-analyzer': {
"       \       'diagnostics': { 'disabled': ['unresolved-import'] },
"       \       'cargo': { 'loadOutDirsFromCheck': v:true },
"       \       'procMacro': { 'enable': v:true },
"       \       'checkOnSave': { 'command': 'clippy', 'enable': v:true },
"       \       'trace': { 'extension': v:true },
"       \     },
"       \   },
"       \ },
"       \}

" let g:lsc_auto_map = {
"       \ 'ShowHover': 'K',
"       \ 'Completion': 'omnifunc',
"       \}
