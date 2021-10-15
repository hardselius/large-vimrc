set shiftwidth=2
let &softtabstop = &shiftwidth
set expandtab

if executable('sqlformat')
  let &l:formatprg='sqlformat -k upper -r --indent_width ' . &l:shiftwidth . ' -'
  " let &l:formatprg='pg_format --spaces ' . &l:shiftwidth . ' --function-case 1 --keyword-case 2 --no-extra-line --wrap-comment'
endif
