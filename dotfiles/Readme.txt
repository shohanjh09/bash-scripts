wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb
sudo apt install ./nvim-linux64.deb
nvim

echo alias vim=nvim >> .zshrc
source .zshrc

sudo apt install fzf
sudo apt-get install ripgrep
sudo apt-get install dos2unix 
export PATH="$HOME/.local/bin:$PATH"
cd dotfiles
dos2unix install
./install

tmux
vim
:e nvim/lua/user/plugins.lua
:PackerSync

cd .local/share/nvim/site/pack/packer/opt/phpactor && composer install --no-dev --optimize-autoloader