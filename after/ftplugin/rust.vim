let b:ale_linters = {'rust': ['rls', 'cargo']}
let b:ale_fixers = {'rust': ['rustfmt']}
let b:ale_fix_on_save = 1
setlocal omnifunc=ale#completion#OmniFunc
