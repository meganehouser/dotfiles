# 少し凝った zshrc
# License : MIT
# http://mollifier.mit-license.org/

########################################
source ~/.apps/zsh-notify/notify.plugin.zsh
# 環境変数
export LANG=ja_JP.UTF-8
export PATH="$PATH:/opt/local/bin:/opt/local/sbin"
export PATH="$PATH:$HOME/.cargo/bin"
export PATH="$PATH:/usr/local/opt/mysql-client/bin"
export PATH="$PATH:/usr/local/Cellar/mono/5.18.0.225/bin/"
export PATH="$HOME/.ndenv/shims:$PATH"
export PATH="$PATH:$HOME/projects/go/bin"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:$HOME/Library/Python/3.6/bin"
export GOPATH="$HOME/projects/go"
export EDITOR=/usr/local/bin/nvim
export PIPENV_VENV_IN_PROJECT=true
export XDG_CONFIG_HOME="$HOME/.config"
export TERM=xterm-256color
export MONO_GAC_PREFIX="/usr/local"
export DJANGO_READ_DOT_ENV_FILE=True
export LDFLAGS="-L/usr/local/opt/openssl/lib"
export SYS_NOTIFIER="/usr/local/bin/terminal-notifier"

eval "$(ndenv init -)"

# 色を使用出来るようにする
autoload -Uz colors
colors

# emacs 風キーバインドにする
bindkey -e

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# プロンプト
# 1行表示
# PROMPT="%~ %# "
# 2行表示
PROMPT="%{${fg[green]}%}[%n@%m]%{${reset_color}%} %~
%# "


# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

########################################
# 補完
# 補完機能を有効にする
autoload -Uz compinit
compinit

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'


########################################
# vcs_info
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

function _update_vcs_info_msg() {
    LANG=en_US.UTF-8 vcs_info
    RPROMPT="${vcs_info_msg_0_}"
}
add-zsh-hook precmd _update_vcs_info_msg


########################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

########################################
# キーバインド

# ^R で履歴検索をするときに * でワイルドカードを使用出来るようにする
bindkey '^R' history-incremental-pattern-search-backward

########################################
# エイリアス

alias la='ls -a'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias mkdir='mkdir -p'

# sudo の後のコマンドでエイリアスを有効にする
alias sudo='sudo '

# グローバルエイリアス
alias -g L='| less'
alias -g G='| grep'

# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1 ; then
    # Mac
    alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
    # Linux
    alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
    # Cygwin
    alias -g C='| putclip'
fi


alias kdiff3='/Applications/kdiff3.app/Contents/MacOS/kdiff3'
alias stree='open /Applications/SourceTree.app'
alias fork='open /Applications/Fork.app'
alias actv='source .venv/bin/activate'
alias workon='source .venv/bin/activate'
alias mkvenv='python3 -m venv .venv --prompt $(basename `pwd`)'
alias fcd='cd $(fd | fzf)'
alias ftpt='footprint -P | pbcopy'
alias ls='exa'
alias ll='exa -ahl --git'
alias plantuml-server='docker run -d -p 8081:8080 plantuml/plantuml-server:jetty'
alias bc='eva'

########################################

# vim:set ft=zsh:
# Override auto-title when static titles are desired ($ title My new title)
title() { export TITLE_OVERRIDDEN=1; echo -en "\e]0;$*\a"}
# Turn off static titles ($ autotitle)
autotitle() { export TITLE_OVERRIDDEN=0 }; autotitle
# Condition checking if title is overridden
overridden() { [[ $TITLE_OVERRIDDEN == 1 ]]; }
# Echo asterisk if git state is dirty
gitDirty() { [[ $(git status 2> /dev/null | grep -o '\w\+' | tail -n1) != ("clean"|"") ]] && echo "*" }

# Show cwd when shell prompts for input.
precmd() {
   if overridden; then return; fi
   cwd=${$(pwd)##*/} # Extract current working dir only
   print -Pn "\e]0;$cwd$(gitDirty)\a" # Replace with $pwd to show full path
}

# Prepend command (w/o arguments) to cwd while waiting for command to complete.
preexec() {
   if overridden; then return; fi
   printf "\033]0;%s\a" "${1%% *} | $cwd$(gitDirty)" # Omit construct from $1 to show args
}


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


function fd-fzf() {
  local target_dir=$(fd -t d -I -H -E ".git"| fzf-tmux --reverse --query="$LBUFFER")
  local current_dir=$(pwd)
 
  if [ -n "$target_dir" ]; then
    BUFFER="cd ${current_dir}/${target_dir}"
    zle accept-line
  fi
 
  zle reset-prompt
}
#zle -N fd-fzf

# Wasmer
export WASMER_DIR="/Users/satoshiterajima/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

function jkj(){
    local selected=$(jump-kun)
    if [[ -n $selected ]]; then
        \cd $selected
    fi
}

function gq() {
  local selected_dir=$(ghq list -p | fzf --query "$LBUFFER")
  if [ -n "$selected_dir" ]; then
    print -z "cd ${selected_dir}"
  fi
}
