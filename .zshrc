# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
ZSH_THEME="dracula"

# use dircolors
# eval `dircolors ~/.dir_colors/dircolors`
eval `dircolors ~/.dir_colors/dircolors_nord`

# You may need to manually set your language environment
export LANG=en_US.UTF-8

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(
	zsh-autosuggestions zsh-syntax-highlighting
	conda-zsh-completion extract
	sudo z git
	)

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"

# >>> alias begin >>

source $ZSH/oh-my-zsh.sh
alias c="clear"
alias r="ranger"
alias rb="reboot"
alias sf="screenfetch"
alias pf="poweroff"
alias sr="source"
alias sysctl="systemctl"


# config bare repo
alias config="/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"
alias conf="config"
alias confp="config push"
alias confl="config pull"

alias ca="config add"
alias cau="ca -u"
alias cm="config commit"
alias cst="config status"
alias crm="config rm"

alias reclash="sysctl restart clash" 		# restart clash
alias rx="xmonad --recompile; xmonad --restart" # restart xmonad

# <<< alias end <<<

# proxy settings
proxyon() {
    export http_proxy=http://127.0.0.1:9981
    export https_proxy=http://127.0.0.1:9981
    echo "proxy is now firing up."
}

proxyoff() {
    unset http_proxy
    unset https_proxy
    echo "proxy is now canceled."
}

export all_proxy="socks5://127.0.0.1:9981"



# >>> path setting >>>

# custom path setting
export WORKSHOP="$HOME/workshop"
export SCRIPTS="$WORKSHOP/scripts"
export PATH="$SCRIPTS/pdf2pptx:$PATH"
export TERMINFO=/usr/share/terminfo

# editor seeting
export EDITOR=vim
export VISUAL=/usr/bin/vim

# doom emacs
export PATH=$PATH:$HOME/.emacs.d/bin

# java setting
#export JAVA_HOME=/usr/lib/jvm/java-17-openjdk

# spark setting
export SPARK_HOME=/opt/spark
export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin

# go setting
export GOPATH=$(go env GOPATH) # Set GOPATH
export GO111MODULE=on

# volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# <<< path setting <<<

# conda
[ -f /opt/miniconda3/etc/profile.d/conda.sh ] && source /opt/miniconda3/etc/profile.d/conda.sh

# ghcup
[ -f "/home/azathoth/.ghcup/env" ] && source "/home/azathoth/.ghcup/env" # ghcup-env

# opam configuration
[[ ! -r /home/azathoth/.opam/opam-init/init.zsh ]] || source /home/azathoth/.opam/opam-init/init.zsh > /dev/null 2> /dev/null

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
