set number
syntax on
set tabstop=4
set shiftwidth=4
set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey
filetype indent on
set autoindent
set cursorline
set wildmenu
set lazyredraw
set showmatch
set incsearch
set hlsearch
set autowrite
set ignorecase
set smartcase
set splitbelow
set splitright

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>


" highlight last inserted text
nnoremap gV `[v`]

nmap J <Nop>
inoremap jk <esc>

inoremap <C-f> <C-x><C-o>

augroup completion_preview_close
  autocmd!
  autocmd CompleteDone * if !&previewwindow && &completeopt =~ 'preview' | silent! pclose | endif
augroup END

set number relativenumber

augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

let mapleader=","

" Go to tab by number
noremap <leader>1 1gt
noremap <leader>2 2gt
noremap <leader>3 3gt
noremap <leader>4 4gt
noremap <leader>5 5gt
noremap <leader>6 6gt
noremap <leader>7 7gt
noremap <leader>8 8gt
noremap <leader>9 9gt

call plug#begin('~/.vim/plugged')
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'christoomey/vim-tmux-navigator'
call plug#end()

" Write all buffers before navigating from Vim to tmux pane
let g:tmux_navigator_save_on_switch = 1

function SetGoOpts()
  nmap <leader>r  :GoReferrers<CR>
  nmap <leader>t  <Plug>(go-test)
  nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
  nmap <Leader>c <Plug>(go-coverage-toggle)
  nnoremap <leader>j :GoDecls<CR>
  nmap <leader>d :GoDoc<CR>
  let g:go_fmt_command = "goimports"
  let g:go_highlight_fields = 1
  let g:go_highlight_functions = 1
  let g:go_highlight_function_calls = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_extra_types = 1
  let g:go_highlight_build_constraints = 1
  let g:go_highlight_generate_tags = 1
  nmap <Leader>i <Plug>(go-info)
  let g:go_auto_type_info = 1
endfunction

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go call SetGoOpts()
