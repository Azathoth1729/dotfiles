########### This is My Zsh configuration ###########

########### ZSH-START ###########

# oh-my-zsh plugins
plugins=(
    zsh-autosuggestions zsh-syntax-highlighting
    # conda-zsh-completion
    extract sudo git
)

# prompt
if [ -x "$(command -v starship)" ]; then
    eval "$(starship init zsh)"
else
    # See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
    ZSH_THEME="robbyrussell"
fi

# soucre oh my zsh
OHMYZSH="$HOME/.oh-my-zsh"
if [ -d $OHMYZSH ]; then
    export ZSH="$HOME/.oh-my-zsh"
    source $ZSH/oh-my-zsh.sh
else
    if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
        source /usr/share/zsh/manjaro-zsh-config
    fi
    # Use manjaro zsh prompt
    if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
        source /usr/share/zsh/manjaro-zsh-prompt
    fi
fi

########### ZSH-END ###########

########### EXPORTS-START ###########

if [ -z "$XDG_CONFIG_HOME" ]; then
    export XDG_CONFIG_HOME="$HOME/.config"
fi
if [ -z "$XDG_DATA_HOME" ]; then
    export XDG_DATA_HOME="$HOME/.local/share"
fi
if [ -z "$XDG_CACHE_HOME" ]; then
    export XDG_CACHE_HOME="$HOME/.cache"
fi
export XMONAD_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/xmonad" # xmonad.hs is expected to stay here
export XMONAD_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/xmonad"
export XMONAD_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/xmonad"

export TERM="xterm-256color" # getting proper colors
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..|clear)"

# custom path setting
export WORKSHOP="$HOME/workshop"
export SCRIPTS="$WORKSHOP/scripts"

export TERMINFO=/usr/share/terminfo

# pdf2pptx
export PATH="$SCRIPTS/pdf2pptx:$PATH"

# doom emacs
export PATH=$PATH:$HOME/.emacs.d/bin

# java
#export JAVA_HOME=/usr/lib/jvm/java-17-openjdk

# spark
export SPARK_HOME=/opt/spark
export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

# go
if [ -x "$(command -v go)" ]; then
    export GOPATH=$(go env GOPATH) # Set GOPATH
    export GO111MODULE=on
    export PATH=$PATH:$GOPATH/bin
fi

# volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# rust path
export RS_BIN="$HOME/.cargo/bin"
export PATH="$HOME/.cargo/bin:$PATH"

# rust source settings
export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"

# llvm

if [ -d "/opt/homebrew/opt/llvm" ]; then
  export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

  export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

fi

########### EXPORTS-END ###########

########### ALIASES-START ###########

## usual
alias c="clear"
alias sr="source"

## sys
alias rb="reboot"
alias pf="poweroff"
alias sysctl="sudo systemctl"

# mkdir create parents by default
alias mkdir="mkdir -pv"

# ln confirmations
alias ln="ln -i"

# editor
alias em="emacsclient -t -a ''"

# restart xmonad
alias rx="xmonad --recompile; xmonad --restart"

# switch between shells
# I do not recommend switching default SHELL from bash.
alias tobash="sudo chsh $USER -s /bin/bash && echo 'Now log out.'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo 'Now log out.'"

## git bare repo alias for dotfiles
if [ -d "$HOME/dotfiles" ]; then
    alias config="/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"
    alias con="config"
    alias conp="config push"
    alias conl="config pull"
    alias cond="config diff"
    alias ca="config add"
    alias cau="ca -u"
    alias cm="config commit -v"
    alias cst="config status"
    alias crm="config rm -r --cached"
    alias crs="config restore"
    alias crst="config restore --staged"
fi

########### ALIASE-END ###########

########### APPLICATION-START ###########

# changing "ls" to "exa"
if [ -x "$(command -v eza)" ]; then
    alias ls='eza -al --color=always --group-directories-first' # my preferred listing
    alias la='eza -a --color=always --group-directories-first'  # all files and dirs
    alias ll='eza -l --color=always --group-directories-first'  # long format
    alias lt='eza -aT --color=always --group-directories-first' # tree listing
    alias l.='eza -a | egrep "^\."'
else
    alias ls="ls -lAh --color=tty" # list dotfiles only
fi

# "bat" as manpager
if [ -x "$(command -v bat)" ]; then
    export MANROFFOPT="-c"
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# nvim
if [ -x "$(command -v nvim)" ]; then
    export EDITOR=/usr/bin/nvim
    export VISUAL=/usr/bin/nvim
    alias v="nvim"
elif [ -x "$(command -v vim)" ]; then
    export EDITOR=/usr/bin/vim
    export VISUAL=/usr/bin/vim
    alias v="vim"
else
    echo "nvim/vim not found"
fi

# neovide
if [ -x "$(command -v neovide)" ]; then
    alias vd="neovide"
fi

# ranger
if [ -x "$(command -v ranger)" ]; then
    alias r="ranger"
fi

# screenfetch
if [ -x "$(command -v screenfetch)" ]; then
    alias sf="screenfetch"
fi

# Set up fzf key bindings and fuzzy completion


if [ -x "$(command -v fzf)" ]; then
    source <(fzf --zsh)
  if [ -x "$(command -v nvim)" ]; then
      alias inv='nvim $(fzf -m --preview "bat --color=always {}")'
  fi
fi


# mcfly
if [ -x "$(command -v mcfly)" ]; then
    eval "$(mcfly init zsh)"
fi

# zoxide
if [ -x "$(command -v zoxide)" ]; then
    eval "$(zoxide init zsh)"
fi

########### APPLICATION-END ###########

########### Eval & Source-START ###########

# use dircolors
if [ -f $HOME/.dir_colors/dircolors_nord ] && [ -x "$(command -v dircolors)" ]; then
    eval $(dircolors $HOME/.dir_colors/dircolors_nord)
fi

# conda
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# ghcup
[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env

# opam (Ocaml)
[[ ! -r /home/azathoth/.opam/opam-init/init.zsh ]] || source $HOME/.opam/opam-init/init.zsh >/dev/null 2>/dev/null

########### Eval and Source-END ###########

########### UTIL-FUNCS-START ###########

## proxy related function
function pr() {
    case $1 in
    show)
        echo http_proxy:$http_proxy
        echo https_proxy:$https_proxy
        echo all_proxy:$all_proxy
        ;;
    off)
        unset http_proxy
        unset https_proxy
        echo "uset http_proxy https_proxy"
        ;;
    on)
        export http_proxy=http://127.0.0.1:9999
        export https_proxy=http://127.0.0.1:9999
        echo "proxy is now firing up."
        echo http_proxy=$http_proxy
        echo https_proxy=$https_proxy
        echo all_proxy=$all_proxy
        ;;
    on_capital)
        export HTTP_PROXY=http://127.0.0.1:9999
        export HTTPS_PROXY=http://127.0.0.1:9999
        echo "proxy is now firing up."
        echo HTTP_PROXY=$HTTP_PROXY
        echo HTTPS_PROXY=$HTTPS_PROXY
        echo all_proxy=$all_proxy
        ;;
    with)
        echo $2
        export http_proxy=http://127.0.0.1:$2
        export https_proxy=http://127.0.0.1:$2
        echo "proxy is now firing up."
        echo http_proxy=$http_proxy
        echo https_proxy=$https_proxy
        ;;
    esac
}

## navigation
up() {
    local d=""
    local limit="$1"

    # Default to limit of 1
    if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
        limit=1
    fi

    for ((i = 1; i <= limit; i++)); do
        d="../$d"
    done

    # perform cd. Show error if cd fails
    if ! cd "$d"; then
        echo "Couldn't go up $limit dirs."
    fi
}

## swap two files
swap() {
    local TMPFILE=tmp.$$
    sudo mv "$1" $TMPFILE
    sudo mv "$2" "$1"
    sudo mv $TMPFILE "$2"
}

## scp && ssh

# scp locally
scp-local() {
    local hostname=$1 # in host name ssh config
    local src=$2
    local tar=$3
    echo moving $src to $hostname:$tar...
    scp -rF $HOME/.ssh/config $src $hostname:$tar
}

# show ssh config
scp-config() {
    bat $HOME/.ssh/config
}

# quickly edit zsh config uisng $EDITOR
econ() {
    $EDITOR $HOME/.zshrc
}

########### UTIL-FUNCS-END ###########

