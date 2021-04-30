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

set belloff=all            " beep音を消す


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

let test#strategy = "dispatch" " vim-testにてテスト実行後quickfixを使えるようにする

" vim-plugでプラグインを管理する
call plug#begin()
Plug 'tpope/vim-vinegar' " tree表示関連コマンド
Plug 'ctrlpvim/ctrlp.vim' " ctrl-P 便利コマンド
Plug 'easymotion/vim-easymotion' " カーソル位置移動コマンド
" Plug 'valloric/youcompleteme' " 補完
Plug 'mileszs/ack.vim' " Ackコマンド
Plug 'tpope/vim-unimpaired' " リスト移動キーバインド
Plug 'tpope/vim-fugitive' " git操作
Plug 'tpope/vim-dispatch' " コマンドバックグラウンド実行関連
Plug 'janko-m/vim-test' " test実行コマンド
" Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' } " go用プラグイン
" Plug 'vim-ruby/vim-ruby'
Plug 'vim-airline/vim-airline' " データ表示
Plug 'yegappan/mru' " 開いたファイル履歴
Plug 'sebdah/vim-delve' " go用デバッガ
Plug 'mattn/vim-maketable' " テーブル記述サポート

" lsp関連 参考: https://mattn.kaoriya.net/software/vim/20191231213507.htm
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'mattn/vim-lsp-icons'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
call plug#end()


" コントロールキーとhjklで分割されたウィンドウ間をすばやく移動する
noremap <c-h> <c-w><c-h>
noremap <c-j> <c-w><c-j>
noremap <c-k> <c-w><c-k>
noremap <c-l> <c-w><c-l>
" コントロールキーとhjklで分割されたウィンドウ間をすばやく移動する ここまで


set foldmethod=indent               " 折りたたみ設定

set wildmenu                        " Tabによる自動補完を有効化
set wildmode=list:longest,full      " 最長マッチまで補完してから自動補完メニューを開く

set number                          " 行番号表示
set hlsearch                        " 検索ハイライト
set clipboard=unnamed,unnamedplus   " システムのクリップボード(*)

" 参考)https://blog.craftz.dog/my-dev-workflow-using-tmux-vim-48f73cc4f39e

" 画面分割
" nmap ss :split<Return><C-w>w
" nmap sv :vsplit<Return><C-w>w

" 画面移動
" map sh <C-w>h
" map sk <C-w>k
" map sj <C-w>j
" map sl <C-w>l

" タブ切り替え
" nmap <S-Tab> :tabprev<Return>
" nmap <Tab> :tabnext<Return>

" 自動改行off
set tw=0

" テストをdelveで実行するようにする設定（https://github.com/vim-test/vim-test#go
nmap <silent> t<C-n> :TestNearest<CR>
function! DebugNearest()
    let g:test#go#runner = 'delve'
    TestNearest
    unlet g:test#go#runner
endfunction
nmap <silent> t<C-d> :call DebugNearest()<CR>
" テストをdelveで実行するようにする設定（https://github.com/vim-test/vim-test#go ここまで

" lspの設定 参考(https://mattn.kaoriya.net/software/vim/20191231213507.htm)
if empty(globpath(&rtp, 'autoload/lsp.vim'))
  finish
endif

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> <f2> <plug>(lsp-rename)
  inoremap <expr> <cr> pumvisible() ? "\<c-y>\<cr>" : "\<cr>"
endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
command! LspDebug let lsp_log_verbose=1 | let lsp_log_file = expand('~/lsp.log')

let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:asyncomplete_auto_popup = 0
let g:asyncomplete_auto_completeopt = 0
let g:asyncomplete_popup_delay = 200
let g:lsp_text_edit_enabled = 1
" lspの設定 参考(https://mattn.kaoriya.net/software/vim/20191231213507.htm)ここまで
