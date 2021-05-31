filetype plugin indent on
au BufRead,BufNewFile *.piq,*.piqi set ft=piq
au BufRead,BufNewFile * if ( &ft == 'erlang' || &ft == 'haskell' || &ft == 'python' ) | setlocal expandtab | endif
au BufRead,BufNewFile * if &ft == 'ocaml' | nmap <F12> i(*  *)<Esc>| imap <F12> (*  *)| endif

if has("gui_running")
    set guioptions-=T
    "set t_Co=256
    "set background=dark
    colorscheme moria
    let moria_fontface = 'mixed'
    "set nonu
else
    "colorscheme zellner
    "set background=dark
    "set nonu
endif
set guicursor=a:blinkon0
set tabstop=4
set shiftwidth=4
set guifont=DejaVu\ Sans\ Mono\ 15
"set guifont=Liberation\ Mono\ 15
"set guifont=Terminus\ Bold\ 16
hi normal guibg=grey5
set autoindent
set shortmess=a
"if &ft == 'ocaml'
"	nmap <F12> i(*  *)<Esc>
"	imap <F12> (*  *)
"endif
set modeline
set viminfo='50,/20,:20,@20,f1
set ignorecase
syntax on
filetype plugin indent on
hi normal guibg=grey5
hi Comment guifg=darkcyan ctermfg=darkcyan
