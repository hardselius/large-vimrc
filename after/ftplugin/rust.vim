let g:ale_linters = {'rust': ['analyzer', 'cargo']}
let g:ale_fixers = {'rust': ['rustfmt']}
let g:ale_fix_on_save = 1
setlocal omnifunc=ale#completion#OmniFunc
