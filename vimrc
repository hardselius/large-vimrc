" filetype support
filetype plugin indent on
syntax on

runtime macros/matchit.vim

" various settings
set autoindent                    " Minimal automatic indent for any filetype.
set autoread                      " Auto reread changed files without asking.
set backspace=indent,eol,start    " Proper backspace behaviour.
set clipboard^=unnamed            " System clipboard.
set foldlevelstart=999            " Open all the folds.
set foldmethod=indent             " Because it's cleaner.
set grepprg=LC_ALL=C\ grep\ -nrsH " Improve default grep.
set hidden                        " Prefer hiding over unloading buffers.
set incsearch                     " Shows the match while typing.
set laststatus=2                  " Always show status line.
set noswapfile                    " No swapfiles.
set number                        " Show line numbers.
set path=.,,**                    " Search relative to current file.
set ruler                         " Shows line,col at bottom right.
set shiftround                    " Round indentation to nearest multile of 'sw'
set tags=./tags;,tags;            " Tags relative to current file + dir + parents recursively.
set virtualedit=block             " Allow virtual editing in Visual block mode.
set visualbell t_vb=              " No beep or flash
set wildcharm=<C-z>               " Macro-compatible command-line wildchar.
set wildmenu                      " Command-line completion.

colorscheme jellybeans

" use ripgrep if it's there
if executable('rg')
  set grepformat=%f:%l:%c:%m,%f:%l:%m
  set grepprg=rg\ --vimgrep\ --no-heading\ --hidden\ $*  " Use ripgrep
endif

augroup myvimrc
  autocmd!
  " automatic loction/quickfix window
  autocmd QuickFixCmdPost [^l]* cwindow
  autocmd QuickFixCmdPost    l* lwindow
  autocmd VimEnter            * cwindow
  autocmd FileType gitcommit nnoremap <buffer> { ?^@@<CR>|nnoremap <buffer> } /^@@<CR>|setlocal iskeyword+=-
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

" TODO: definitions

" matches
nnoremap ,i :ilist /
nnoremap [I [I:ijump<Space><Space><Space><C-r><C-w><S-Left><Left><Left>
nnoremap ]I ]I:ijump<Space><Space><Space><C-r><C-w><S-Left><Left><Left>

" quickfix entries
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>

" search and replace
nnoremap <Space><Space> :'{,'}s/\<<C-r>=expand("<cword>")<CR>\>/
nnoremap <Space>%       :%s/\<<C-r>=expand("<cword>")<CR>\>/

" global commands
nnoremap ,g :g//#<Left><Left>

" windows
nnoremap <silent> <C-w>z :wincmd z<Bar>cclose<Bar>lclose<CR>

" improve grep
function! Grep(...)
  return system(join([&grepprg] + [expandcmd(join(a:000, ' '))], ' '))
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<f-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<f-args>)
nnoremap ,G :Grep 

cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
cnoreabbrev <expr> lgrep (getcmdtype() ==# ':' && getcmdline() ==# 'lgrep') ? 'LGrep' : 'lgrep'

" scratch buffer
command! SC vnew | setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
command! -nargs=1 -complete=command -bar -range Redir silent call redir#Redir(<q-args>, <range>, <line1>, <line2>)
nnoremap ,r :Redir<Space>

" portable git blame
command! -range GB echo join(systemlist("git -C " . shellescape(expand('%:p:h')) . " blame -L <line1>,<line2> " . expand('%:t')), "\n")

" various stuff
let $MYWIKI="~/src/wiki/Home.md"
nnoremap ,m :!mkdir -p %:h<CR>
nnoremap <Leader>ni :e $NOTES/index.md<CR>:cd $NOTES<CR>

" plugins
let g:terraform_fmt_on_save = 1
let g:netrw_liststyle = 3
let g:netrw_localrmdir='rm -r'
