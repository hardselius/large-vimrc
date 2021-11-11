if exists("g:loaded_preserve")
  finish
endif
let g:loaded_preserve = 1

function! s:preserve(cmd)
  echo a:cmd
  " Save the last search.
  let search = @/

  " Save the current cursor position.
  let cursor_position = getpos('.')

  " Save the current window position.
  normal! H
  let window_position = getpos('.')
  call setpos('.', cursor_position)

  " Execute the cmd.
  execute a:cmd

  " Restore the last search.
  let @/ = search

  " Restore the previous window position.
  call setpos('.', window_position)
  normal! zt

  " Restore the previous cursor position.
  call setpos('.', cursor_position)
endfunction

command! -nargs=1 -complete=shellcmd Filter silent call s:preserve('silent %!' . <q-args>)
