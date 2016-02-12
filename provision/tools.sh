#!/bin/bash
# simulate neat MacOSX tool pbcopy | pbpaste using xclip

echo "alias pbcopy='xclip -selection clipboard'" >> /home/vagrant/.bashrc
echo "alias pbpaste='xclip -selection clipboard -o'" >> /home/vagrant/.bashrc

# Configure Vim using Pathogen for plugin management
#
mkdir -p /home/vagrant/.vim/autoload && mkdir -p /home/vagrant/.vim/bundle
curl -sSLo /home/vagrant/.vim/autoload/pathogen.vim https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim
cd /home/vagrant/.vim/bundle
git clone git://github.com/tpope/vim-sensible.git
git clone git://github.com/tpope/vim-surround.git
git clone git://github.com/scrooloose/syntastic.git
git clone git://github.com/scrooloose/nerdtree.git
git clone git://github.com/msanders/snipmate.vim.git

# .vimrc
VIM_RC=/home/vagrant/.vimrc
if [ -f $VIM_RC ];
then
	printf "\nDisabling default .vimrc...\n"
	rm -v $VIM_RC
fi
ln -s /vagrant/config/vim.conf $VIM_RC

# Make sure vim directory is owned by vagrant
chown vagrant:vagrant -R /home/vagrant/.vim
chmod 775 -R /home/vagrant/.vim
