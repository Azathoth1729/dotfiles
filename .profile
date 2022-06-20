# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

export XMODIFIERS=@im=fcitx5
export XIM_SERVERS=fcitx5
export GTK_IM_MODULE=fcitx5
export QT4_IM_MODULE=fcitx5
export QT_IM_MODULE=fcitx5
export XMODIFIERS="@im=fcitx5"

#export EDITOR="emacsclient -t -a ''"              # $EDITOR use Emacs in terminal
#export VISUAL="emacsclient -c -a emacs"           # $VISUAL use Emacs in GUI mode
export TERMINFO=/usr/share/terminfo

# locale
#export LC_ALL=C
export XDG_CONFIG_HOME="$HOME/.config"

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# volta
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# cargo
source "$HOME/.cargo/env"

# doom emacs
export PATH=$PATH:$HOME/.emacs.d/doom/bin
