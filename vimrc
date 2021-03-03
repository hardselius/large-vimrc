" filetype support
filetype plugin indent on
syntax on

runtime macros/matchit.vim

" various settings
set autoindent
set autoread
set backspace=indent,eol,start
set clipboard^=unnamed
set complete+=d
set completeopt+=menuone,noinsert,noselect
set foldlevelstart=999
set foldmethod=indent
set grepprg=LC_ALL=C\ grep\ -nrsH
set hidden
set incsearch
set laststatus=2
set noswapfile
set number
set path=.,,**
set ruler
set shiftround
set tags=./tags;,tags;
set virtualedit=block
set visualbell t_vb=
set wildcharm=<C-z>
set wildmenu

colorscheme grim

" use ripgrep if it's there
if executable('rg')
  set grepformat=%f:%l:%c:%m
  set grepprg=rg\ --vimgrep\ --no-heading\ $*
endif

augroup myvimrc
  autocmd!
  " automatic location/quickfix window
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost    l* lwindow
  autocmd VimEnter            * cwindow
  autocmd FileType gitcommit nnoremap <buffer> { ?^@@<CR>|nnoremap <buffer> } /^@@<CR>|setlocal iskeyword+=-
  autocmd CompleteDone * silent! pclose
augroup END

" files
nnoremap ,f :find *
nnoremap ,s :sfind *
nnoremap ,v :vertical sfind *
nnoremap ,t :tabfind *

" buffers
nnoremap ,b :buffer *
nnoremap ,B :sbuffer *
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap ,a :buffer#<CR>

" command-line
cnoremap <C-k> <Up>
cnoremap <C-j> <Down>

" tags
nnoremap ,j :tjump /
nnoremap ,p :ptjump /

" definitions
nnoremap ,d :dlist /
nnoremap [D [D:djump<Space><Space><Space><C-r><C-w><S-Left><Left>
nnoremap ]D ]D:djump<Space><Space><Space><C-r><C-w><S-Left><Left>

" matches
nnoremap ,i :ilist /
nnoremap [I [I:ijump<Space><Space><Space><C-r><C-w><S-Left><Left><Left>
nnoremap ]I ]I:ijump<Space><Space><Space><C-r><C-w><S-Left><Left><Left>

" location/quickfix entries
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [l :lprevious<CR>
nnoremap ]l :lnext<CR>

" search and replace
nnoremap <Space><Space> :'{,'}s/\<<C-r>=expand("<cword>")<CR>\>/
nnoremap <Space>%       :%s/\<<C-r>=expand("<cword>")<CR>\>/

" global commands
nnoremap ,g :g//#<Left><Left>

" windows
nnoremap <silent> <C-w>z :wincmd z<Bar>cclose<Bar>lclose<CR>

" grepping
function! Grep(...)
  return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)

cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

" searching
cnoremap <expr> <Tab>   getcmdtype() == "/" \|\| getcmdtype() == "?" ? "<CR>/<C-r>/" : "<C-z>"
cnoremap <expr> <S-Tab> getcmdtype() == "/" \|\| getcmdtype() == "?" ? "<CR>?<C-r>/" : "<S-Tab>"

" listing
cnoremap <expr> <CR> <SID>CCR()
function! s:CCR()
	command! -bar Z silent set more|delcommand Z
	if getcmdtype() ==# ':'
		let cmdline = getcmdline()
		    if cmdline =~# '\v\C^(dli|il)' | return "\<CR>:" . cmdline[0] . 'jump   ' . split(cmdline, ' ')[1] . "\<S-Left>\<Left>\<Left>"
		elseif cmdline =~# '\v\C^(cli|lli)' | return "\<CR>:silent " . repeat(cmdline[0], 2) . "\<Space>"
		elseif cmdline =~# '\C^changes' | set nomore | return "\<CR>:Z|norm! g;\<S-Left>"
		elseif cmdline =~# '\C^ju' | set nomore | return "\<CR>:Z|norm! \<C-o>\<S-Left>"
		elseif cmdline =~# '\v\C(#|nu|num|numb|numbe|number)$' | return "\<CR>:"
		elseif cmdline =~# '\C^ol' | set nomore | return "\<CR>:Z|e #<"
		elseif cmdline =~# '\v\C^(ls|files|buffers)' | return "\<CR>:b"
		elseif cmdline =~# '\C^marks' | return "\<CR>:norm! `"
		elseif cmdline =~# '\C^undol' | return "\<CR>:u "
		else | return "\<CR>" | endif
	else | return "\<CR>" | endif
endfunction

" misc

" scratch buffer
command! SC vnew | setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
command! -nargs=1 -complete=command -bar -range Redir silent call redir#Redir(<q-args>, <range>, <line1>, <line2>)
nnoremap ,r :Redir<Space>

" portable git blame
command! -range GB echo join(systemlist("git -C " . shellescape(expand('%:p:h')) . " blame -L <line1>,<line2> " . expand('%:t')), "\n")

" location list :global
set errorformat^=%f:%l:%c\ %m
command! -nargs=1 Global lgetexpr filter(map(getline(1,'$'), {key, val -> expand("%") . ":" . (key + 1) . ":1 " . val }), { idx, val -> val =~ <q-args> })
nnoremap ,G :Global

" create directories
nnoremap ,m :!mkdir -p %:h<CR>

" plugins
let g:netrw_liststyle = 3
let g:netrw_localrmdir='rm -r'
