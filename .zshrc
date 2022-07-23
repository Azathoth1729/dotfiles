# swap ESC and CAPS_LOCK
#setxkbmap -option caps:escape &

# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(
	zsh-autosuggestions 
    zsh-syntax-highlighting
	conda-zsh-completion 
    extract
	sudo git
	)

### EXPORT ###
export TERM="xterm-256color"                      # getting proper colors
export HISTORY_IGNORE="(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..|clear)"


if [ -x "$(command -v nvim)" ]; then
    export EDITOR=/usr/bin/nvim
    export VISUAL=/usr/bin/nvim
else
    export EDITOR=/usr/bin/vim
    export VISUAL=/usr/bin/vim
fi

#export EDITOR="emacsclient -t -a ''"              # $EDITOR use Emacs in terminal
#export VISUAL="emacsclient -c -a emacs"           # $VISUAL use Emacs in GUI mode

# zsh and oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh


# custom path setting
export WORKSHOP="$HOME/workshop"
export SCRIPTS="$WORKSHOP/scripts"


#export PAGER="sh -c 'col -bx | bat -l man -p'"

export TERMINFO=/usr/share/terminfo

## set manpager

# "bat" as manpager
if [ -x "$(command -v bat)" ]; then
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# "vim" as manpager
# "nvim" as manpager

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
fi

# volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# rust path for nvim
export RS_BIN="$HOME/.cargo/bin"

# rust source settings
export RUSTUP_DIST_SERVER="https://rsproxy.cn"
export RUSTUP_UPDATE_ROOT="https://rsproxy.cn/rustup"

### EXPORT ###


### ALIASES ###

## usual
alias c="clear"
alias sr="source"

## sys
alias rb="reboot"
alias pf="poweroff"
alias sysctl="sudo systemctl"

## changing "ls" to "exa"
if [ -x "$(command -v exa)" ]; then
    alias ls='exa -al --color=always --group-directories-first' # my preferred listing
    alias la='exa -a --color=always --group-directories-first'  # all files and dirs
    alias ll='exa -l --color=always --group-directories-first'  # long format
    alias lt='exa -aT --color=always --group-directories-first' # tree listing
    alias l.='exa -a | egrep "^\."' 			    # list dotfiles only
fi 

## mkdir create parents by default
alias mkdir="mkdir -pv"

## confirmations
alias mv="mv -i"
alias cp="cp -i"
alias rm="rm -i"
alias ln="ln -i"

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
fi


## applications

# editor

alias em="emacsclient -t -a ''"

if [ -x "$(command -v nvim)" ]; then
    alias v="nvim"
fi

if [ -x "$(command -v neovide)" ]; then
    alias vd="neovide"
fi

# software
if [ -x "$(command -v ranger)" ]; then
    alias r="ranger"
fi

if [ -x "$(command -v screenfetch)" ]; then
    alias sf="screenfetch"
fi

alias clashst="sysctl status clash"
alias clashr="sysctl restart clash" 		# restart clash
alias rx="xmonad --recompile; xmonad --restart" # restart xmonad

### ALIASES ###



### UTIL FUNCS ###

## proxy
withproxy() {
    export http_proxy=http://127.0.0.1:$1
    export https_proxy=http://127.0.0.1:$1
    export all_proxy=socks5://127.0.0.1:$1
    echo "proxy is now firing up."
    echo http_proxy:$http_proxy 
    echo https_proxy:$https_proxy
    echo all_proxy:$all_proxy
}

onproxy() {
    export http_proxy=http://127.0.0.1:9999
    export https_proxy=http://127.0.0.1:9999
    export all_proxy=socks5://127.0.0.1:9999
    echo "proxy is now firing up."
    echo http_proxy:$http_proxy
    echo https_proxy:$https_proxy
    echo all_proxy:$all_proxy
}

offproxy() {
    unset http_proxy
    unset https_proxy
    unset all_proxy
    echo "uset http_proxy https_proxy all_proxy"
}

showproxy() {
    echo http_proxy:$http_proxy
    echo https_proxy:$https_proxy
    echo all_proxy:$all_proxy
}

## navigation
up() {
  local d=""
  local limit="$1"

  # Default to limit of 1
  if [ -z "$limit" ] || [ "$limit" -le 0 ]; then
    limit=1
  fi

  for ((i=1;i<=limit;i++)); do
    d="../$d"
  done

  # perform cd. Show error if cd fails
  if ! cd "$d"; then
    echo "Couldn't go up $limit dirs.";
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
    local hostname=$1  # in host name ssh config
    local src=$2 
    local tar=$3
    echo moving $src to $hostname:$tar...
    scp -rF $HOME/.ssh/config $src $hostname:$tar
}

# show ssh config
scp-config(){
    bat $HOME/.ssh/config
}

## quickly edit zsh config uisng $EDITOR
econ() {
    $EDITOR $HOME/.zshrc
}


### UTIL FUNCS ###



### Eval and Source ###
# use dircolors
if [ -f $HOME/.dir_colors/dircolors_nord ]; then
eval `dircolors $HOME/.dir_colors/dircolors_nord`
fi

# mcfly
if [ -x "$(command -v mcfly)" ]; then
    eval "$(mcfly init zsh)"
fi

# prompt
if [ -x "$(command -v starship)" ]; then
    eval "$(starship init zsh)"
else
    # Set name of the theme to load --- if set to "random", it will
    # load a random theme each time oh-my-zsh is loaded, in which case,
    # to know which specific one was loaded, run: echo $RANDOM_THEME
    # See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
    ZSH_THEME="robbyrussell"
fi

if [ -x "$(command -v zoxide)" ]; then
    eval "$(zoxide init zsh)"
fi

# conda
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# ghcup
[ -f "/home/azathoth/.ghcup/env" ] && source "/home/azathoth/.ghcup/env" # ghcup-env

# opam configuration
[[ ! -r /home/azathoth/.opam/opam-init/init.zsh ]] || source /home/azathoth/.opam/opam-init/init.zsh > /dev/null 2> /dev/null

### Eval and Source ###

# locale
# LC_CTYPE=zh_CN.UTF-8

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"


# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder


# User configuration
# export MANPATH="/usr/local/man:$MANPATH"


# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"


            
