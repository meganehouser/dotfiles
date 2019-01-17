# install homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# brews
brew update
brew upgrade
brew bundle

# neovim
mkdir ~/.vim/
mkdir ~/.vim/rc/
mkdir ~/.vim/backup/
pip3 install neovim
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts

# symlink
sh symlink.sh
