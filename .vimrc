" => Chapter 1: Getting Started --------------------------------------- {{{
" Basic Python-friendly Vim configuration. Colorscheme is changed from
" 'default' to make screenshots look better in print.

syntax on                  " Enable syntax highlighting.
filetype plugin indent on  " Enable file type based indentation.

set autoindent             " Respect indentation when starting a new line.
set expandtab              " Expand tabs to spaces. Essential in Python.
set tabstop=4              " Number of spaces tab is counted for.
set shiftwidth=4           " Number of spaces to use for autoindent.

set backspace=2            " Fix backspace behavior on most terminals.

colorscheme murphy         " Change a colorscheme.


" すべてのファイルについて永続アンドゥを有効にする
set undofile
if !isdirectory(expand("$HOME/.vim/undodir"))
    call mkdir(expand("$HOME/.vim/undodir"), "p")
endif
set undodir=$HOME/.vim/undodir


" vim-plugがまだインストールされていなければインストールする
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs 
                \ https://raw.github.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let g:plug_timeout = 300 " YouCompleteMeはコンパイルに時間がかかるためタイムアウトを伸ばす

" vim-plugでプラグインを管理する
call plug#begin()
Plug 'tpope/vim-vinegar'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'easymotion/vim-easymotion'
Plug 'mileszs/ack.vim'
Plug 'ycm-core/youCompleteMe', { 'do': './install.py'}
call plug#end()


" コントロールキーとhjklで分割されたウィンドウ間をすばやく移動する
" noremap <c-h> <c-w><c-h>
" noremap <c-j> <c-w><c-j>
" noremap <c-k> <c-w><c-k>
" noremap <c-l> <c-w><c-l>


set foldmethod=indent               " 折りたたみ設定

set wildmenu                        " Tabによる自動補完を有効化
set wildmode=list:longest,full      " 最長マッチまで補完してから自動補完メニューを開く

set number                          " 行番号表示
set hlsearch                        " 検索ハイライト
set clipboard=unnamed,unnamedplus   " システムのクリップボード(*)

" 参考)https://blog.craftz.dog/my-dev-workflow-using-tmux-vim-48f73cc4f39e

" 画面分割
nmap ss :split<Return><C-w>w
nmap sv :vsplit<Return><C-w>w

" 画面移動
map sh <C-w>h
map sk <C-w>k
map sj <C-w>j
map sl <C-w>l

" タブ切り替え
nmap <S-Tab> :tabprev<Return>
nmap <Tab> :tabnext<Return>
