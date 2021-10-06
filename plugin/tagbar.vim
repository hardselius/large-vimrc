if exists('g:loaded_tagbar_config')
  finish
endif
let g:loaded_tagbar_config= 1

nnoremap <Leader>t :Tagbar<CR>

let g:tagbar_compact = 1
let g:tagbar_sort    = 0

hi! link TagbarNestedKind Comment
hi! link TagbarType Comment

nnoremap <Leader>t :Tagbar<CR>
