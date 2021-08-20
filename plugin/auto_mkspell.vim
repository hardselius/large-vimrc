for d in globpath(&runtimepath, 'spell', 1, 1)
  for f in  globpath(d, '*.add', 1, 1)
    if filereadable(f) && (!filereadable(f . '.spl') || getftime(f) > getftime(f .  '.spl'))
      silent exec 'mkspell!' . fnameescape(f)
    endif
  endfor
endfo

command! -nargs=? -bang Spelling setlocal spell<bang> spelllang=<args>
