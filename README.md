* Install [vim-plug](https://github.com/junegunn/vim-plug)
```bat
curl -fLo %USERPROFILE%\.vim\autoload\plug.vim --create-dirs ^
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
* Install [packer](https://github.com/wbthomason/packer.nvim)
```bat
git clone https://github.com/wbthomason/packer.nvim ^
    %LOCALAPPDATA%\nvim-data\site\pack\packer\start\packer.nvim
```
```shell
git clone --depth 1 https://github.com/wbthomason/packer.nvim \
    ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```