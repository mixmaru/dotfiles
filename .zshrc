#####################################################################
#
#  Sample .zshrc file
#  initial setup file for only interactive zsh
#  This file is read after .zshenv file is read.
#
#####################################################################

# zshのデフォルトrcが理解できていないので一旦コメントアウトして様子をみる
# ###
# # Set Shell variable
# # WORDCHARS=$WORDCHARS:s,/,,
# HISTSIZE=2000 HISTFILE=~/.zhistory SAVEHIST=180
PROMPT='%m{%n}%% '
RPROMPT='[%~]'
# 
# # Set shell options
# # 有効にしてあるのは副作用の少ないもの
# setopt auto_cd auto_remove_slash auto_name_dirs 
# setopt extended_history hist_ignore_dups hist_ignore_space prompt_subst
# setopt extended_glob list_types no_beep always_last_prompt
# setopt cdable_vars sh_word_split auto_param_keys pushd_ignore_dups
# # 便利だが副作用の強いものはコメントアウト
# #setopt auto_menu  correct rm_star_silent sun_keyboard_hack
# #setopt share_history inc_append_history
# 
# # Alias and functions
# alias copy='cp -ip' del='rm -i' move='mv -i'
# alias fullreset='echo "\ec\ec"'
# h () 		{history $* | less}
# alias ja='LANG=ja_JP.eucJP XMODIFIERS=@im=kinput2'
alias ls='ls -F' la='ls -a' ll='ls -la'
# mdcd ()		{mkdir -p "$@" && cd "$*[-1]"}
# mdpu ()		{mkdir -p "$@" && pushd "$*[-1]"}
# alias pu=pushd po=popd dirs='dirs -v'
# 
# # Suffix aliases(起動コマンドは環境によって変更する)
# alias -s pdf=acroread dvi=xdvi 
# alias -s {odt,ods,odp,doc,xls,ppt}=soffice
# alias -s {tgz,lzh,zip,arc}=file-roller
# 
# # binding keys
# bindkey -e
# #bindkey '^p'	history-beginning-search-backward
# #bindkey '^n'	history-beginning-search-forward
# 
# # 输窗システムを网脱: 输窗の刁瓢が尸かりやすくなる2つの肋年のみ淡揭
# zstyle ':completion:*' format '%BCompleting %d%b'
# zstyle ':completion:*' group-name ''
autoload -U compinit && compinit

##### historyの設定 #####
# 参考）https://qiita.com/syui/items/c1a1567b2b76051f50c4
# 履歴ファイルの保存先
export HISTFILE=${HOME}/.zsh_history

# メモリに保存される履歴の件数
export HISTSIZE=1000

# 履歴ファイルに保存される履歴の件数
export SAVEHIST=100000

# 重複を記録しない
setopt hist_ignore_dups

# 開始と終了を記録
setopt EXTENDED_HISTORY

##### go bin設定（ghq のインストールで使用） #####
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

##### peco コマンド履歴設定 #####
function peco-select-history() {
    # historyを番号なし、逆順、最初から表示。
    # 順番を保持して重複を削除。
    # カーソルの左側の文字列をクエリにしてpecoを起動
    # \nを改行に変換
    BUFFER="$(history -nr 1 | awk '!a[$0]++' | peco --query "$LBUFFER" | sed 's/\\n/\n/')"
    CURSOR=$#BUFFER             # カーソルを文末に移動
    zle -R -c                   # refresh
}
zle -N peco-select-history
bindkey '^R' peco-select-history

##### cdr 設定 #####
if [[ -n $(echo ${^fpath}/chpwd_recent_dirs(N)) && -n $(echo ${^fpath}/cdr(N)) ]]; then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':completion:*' recent-dirs-insert both
    zstyle ':chpwd:*' recent-dirs-default true
    zstyle ':chpwd:*' recent-dirs-max 1000
    zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/chpwd-recent-dirs"
fi

# cdr peco設定
function peco-cdr () {
    local selected_dir="$(cdr -l | sed 's/^[0-9]\+ \+//' | peco --prompt="cdr >" --query "$LBUFFER")"
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
}
zle -N peco-cdr
bindkey '^[r' peco-cdr

# pyenvのロード設定
# export PATH="/home/mix/.pyenv/bin:$PATH"
# eval "$(pyenv init -)"
# eval "$(pyenv virtualenv-init -)"

# pipenvの環境をフォルダ内に配置するようにした
export PIPENV_VENV_IN_PROJECT=true

# rbenvの設定
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# nodenv
export PATH="$HOME/.nodenv/bin:$PATH"
eval "$(nodenv init -)"

# userスクリプト用PATH追加
export PATH="$HOME/bin:$PATH"

# psqlのパス設定
export PATH=/usr/local/Cellar/postgresql@9.4/9.4.21/bin/:$PATH

# iconvのエイリアス
alias iconv='/usr/local/opt/libiconv/bin/iconv'

# qt5.5の設定
export PATH="$(brew --prefix qt@5.5)/bin:$PATH"

# Tさんとなんやかんややっていた時に追加したpath
export PATH="/usr/local/opt/libxml2/bin:$PATH"
