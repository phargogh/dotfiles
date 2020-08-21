set -e

mkdir -p workspace/phargogh

# wget is available on ubuntu 20.04 by default (as far as I can tell)
sudo apt update
sudo apt install -y git vim curl vim-youcompleteme

git clone git@github.com:phargogh/dotfiles

# install plug.vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Copy vimrc to the right place
wget https://raw.githubusercontent.com/phargogh/dotfiles/master/vim/_vimrc -O ~/.vimrc

# Install vim-plugins and quit immediately.
vim +PlugInstall +qall!

# If we're doing python development, install needed packages for linters.
sudo apt install -y python3 python3-pyflakes
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86-x86_64.sh

# If we're doing C development, install appropriate compilers and libraries
sudo apt install -y build-essential

# If we need to be able to commit and push to github, create a new ssh key.
ssh-keygen -t rsa -b 4096

echo "\n\nCopy this into github:\n\n"
cat ~/.ssh/id_rsa.pub
