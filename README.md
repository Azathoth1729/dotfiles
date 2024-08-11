# dotfiles

Personal bare repo for configuration backup on linux system

## Setup dotfiles

[Dotfiles: Best way to store in a bare git repository](https://www.atlassian.com/git/tutorials/dotfiles)

### Install dotfiles onto a new system

```bash
alias config="/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"

git clone --bare https://github.com/Azathoth1729/dotfiles.git $HOME/dotfiles

mkdir -p .config-backup

config checkout

if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;

config checkout

config config status.showUntrackedFiles no

```

## Setup oh-my-zsh

### Step 1: install oh my zsh

[oh my zsh offical site](https://ohmyz.sh/)

### Step 2: install plugins

+ [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh)
+ [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh)

## My Working Environment

### Windows Manager

#### xmonad + xmobar

### Useful command line tools

+ vim/neovim
+ ranger
+ mcfly
+ bat
+ fd
+ eza
+ dust
+ ripgrep

### Other frequently used tools

+ zsh + oh-my-zsh
+ alacritty
+ starship
+ conky
+ nitrogen
+ doom

## Links

[on-my-zsh-git-aliases][on-my-zsh-git-aliases]

[on-my-zsh-git-aliases]: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git#aliases
