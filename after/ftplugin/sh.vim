set expandtab
set shiftwidth=2
set softtabstop=2

if executable('shfmt')
  let &l:formatprg='shfmt -i ' . &l:shiftwidth . ' -ln posix -sr -ci -s'
endif
