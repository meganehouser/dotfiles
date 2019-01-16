# install homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# brews
brew update
brew upgrade
brew bundle

# neovim
mkdir ~/.vim/
mkdir ~/.vim/rc/
pip3 install neovim

# symlink
sh symlink.sh
