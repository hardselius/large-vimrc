autocmd BufRead,BufNewFile *.sp call s:set_steampipe_filetype()
autocmd BufRead,BufNewFile *.spc call s:set_steampipe_filetype()

function! s:set_steampipe_filetype() abort
  if &filetype !=# 'hcl'
    set filetype=hcl
  endif
endfunction

