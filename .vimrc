" leader is comma
let mapleader=","

set number
syntax on
set tabstop=4
set shiftwidth=4
set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey
"filetype indent on
"set autoindent
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
set hidden

" Backspace wasn't working, so...
set backspace=indent,eol,start

" Disable arrow keys in normal mode
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" Disable cap J
nmap J <Nop>
" jk for easy escape
inoremap jk <esc>

" Close docs on autocomplete finish
augroup completion_preview_close
  autocmd!
  autocmd CompleteDone * if !&previewwindow && &completeopt =~ 'preview' | silent! pclose | endif
augroup END

" Relative number in normal mode; absolute in insert, command
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
  au CmdlineEnter * set norelativenumber | redraw
  au CmdlineLeave * set relativenumber
augroup END

" Go to buffer by number
nmap <leader>1 <Plug>BufTabLine.Go(1)
nmap <leader>2 <Plug>BufTabLine.Go(2)
nmap <leader>3 <Plug>BufTabLine.Go(3)
nmap <leader>4 <Plug>BufTabLine.Go(4)
nmap <leader>5 <Plug>BufTabLine.Go(5)
nmap <leader>6 <Plug>BufTabLine.Go(6)
nmap <leader>7 <Plug>BufTabLine.Go(7)
nmap <leader>8 <Plug>BufTabLine.Go(8)
nmap <leader>9 <Plug>BufTabLine.Go(9)
nmap <leader>0 <Plug>BufTabLine.Go(0)

" Next/previous buffer
nnoremap gt :bnext <CR>
nnoremap gT :bprevious <CR>

" Close buffer
nnoremap <leader>w :bd <CR>
" Write and close buffer
nnoremap qq :w\|bd<CR>

" Jump to end of word before 80th column
nnoremap <leader>e 80<bar>B

" Plugins
call plug#begin('~/.vim/plugged')
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'ap/vim-buftabline'
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
  Plug 'towolf/vim-helm'
call plug#end()

" Write all buffers before navigating from Vim to tmux pane
let g:tmux_navigator_save_on_switch = 1

" Collection of go-only settings
function SetGoOpts()
  " ctrl-f for easy omni completion
  inoremap <C-f> <C-x><C-o>

  " run :GoBuild or :GoTestCompile based on the go file
  function! s:build_go_files()
    let l:file = expand('%')
    if l:file =~# '^\f\+_test\.go$'
      call go#test#Test(0, 1)
    elseif l:file =~# '^\f\+\.go$'
      call go#cmd#Build(0)
    endif
  endfunction

  " leader-r for referrers
  nmap <leader>r  :GoReferrers<CR>
  " leader-t for test
  nmap <leader>t  <Plug>(go-test)
  " leader-b for build
  nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
  " leader-c for toggle coverage
  nmap <Leader>c <Plug>(go-coverage-toggle)
  " leader-j for declaration of identifier
  nnoremap <leader>j :GoDecls<CR>

  let g:go_fmt_command = "stripblankimports"
  let g:go_highlight_fields = 1
  let g:go_highlight_functions = 1
  let g:go_highlight_function_calls = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_extra_types = 1
  let g:go_highlight_build_constraints = 1
  let g:go_highlight_generate_tags = 1
  let g:go_auto_type_info = 1

  " :AV opens alternate file (test file) in vertical split
  command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
 
endfunction

autocmd FileType go call SetGoOpts()
autocmd BufNewFile,BufRead /Users/ryan.flynn/go/src/github.com/1debit/*.go let g:go_fmt_options = {
    \ 'stripblankimports': '-local github.com/1debit',
    \ }
autocmd BufNewFile,BufRead /Users/ryan.flynn/go/src/github.com/rpflynn22/*.go let g:go_fmt_options = {
    \ 'stripblankimports': '-local github.com/rpflynn22',
    \ }

augroup filetype
  au! BufRead,BufNewFile *.proto setfiletype proto
augroup end

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType vim setlocal ts=2 sts=2 sw=2 expandtab
