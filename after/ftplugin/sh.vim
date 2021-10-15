set shiftwidth=2
let &softtabstop = &shiftwidth
set expandtab

if executable('shfmt')
  let &l:formatprg='shfmt -i ' . &l:shiftwidth . ' -ln posix -sr -ci -s'
endif
