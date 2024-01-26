syntax on
set mouse=
set autoindent
set shortmess=aS
set modeline
set viminfo='50,/25,:50,@25,f1
set ignorecase
set tabstop=4
set shiftwidth=4

"filetype plugin indent on
"au BufRead,BufNewFile *.piq,*.piqi set ft=piq
"au BufRead,BufNewFile * if ( &ft == 'erlang' || &ft == 'haskell' || &ft == 'python' ) | setlocal expandtab | endif
"au BufRead,BufNewFile * if &ft == 'ocaml' | nmap <F12> i(*  *)<Esc>| imap <F12> (*  *)| endif

if has("gui_running")
    set guifont=DejaVu\ Sans\ Mono\ 10
    set guioptions-=T
    set t_Co=256
    set background=dark
    colorscheme srcery
    "set background=light
    "colorscheme grimmjow
    "set background=light
    "colorscheme PaperColor
    "let moria_fontface = 'mixed'
    "set nonu
else
    set guifont=DejaVu\ Sans\ Mono\ 12
    "colorscheme zellner
    set background=dark
    colorscheme desert
    "colorscheme gruvbox-material
    "colorscheme gruvbox
    "set nonu
    hi normal guibg=grey5
    hi Comment guifg=darkgreen ctermfg=darkgreen
    " change blue to magenta
    hi PreProc ctermfg=5
endif
set guicursor=a:blinkon0
"set guifont=DejaVu\ Sans\ Mono\ 12
hi normal guibg=grey5
"if &ft == 'ocaml'
"	nmap <F12> i(*  *)<Esc>
"	imap <F12> (*  *)
"endif
filetype plugin indent on

"set background=dark
hi Comment guifg=darkcyan ctermfg=darkcyan
"hi Comment ctermbg=gray ctermfg=darkcyan

imap <special> <F2> <C-o>:w!<CR>


