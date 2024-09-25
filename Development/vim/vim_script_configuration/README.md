# Neovim Setup Guide

**For a more up to date configuration use the lazy_nvim configuration**

1. Install Neovim
2. Install Vim-Plug
3. Install-Update-Remove Plugins
4. Setup Python & C Code Completions

## Install Neovim

Installation:
```bash
sudo pacman -S neovim
```
Create configuration folder:
```bash
mkdir ~/.config/nvim
```
Create a vim.init file (or download from here) inside ~/.config/nvim
 
## Install Vim-Plug
Go to https://github.com/junegunn/vim-plug and download vim-plug for neovim as follows:
```bash
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```
## Install-Update-Remove Plugins
To install a plugin you should first include in your vim.init config file.  For example:
```bash

call plug#begin()

Plug 'preservim/nerdtree'

call plug#end()

```
Afterwards, open the neovim editor and type:
```bash
:PlugInstall
```
Similarly, to update installed plugins you do so by typing:
```bash
:UpdateRemotePlugins

#or

:PlugUpdate

```
To update vim-plug, you do so by typing:
```bash
:PlugUpgrade
```
To remove a plugin, you will first need to remove the entry on the config file and the type the following on your editor:
```bash
:PlugClean
```
## Setup Python & C code completions

First add Conquer of Completions (COC) in your config file:

```bash
call plug#begin()

Plug 'https://github.com/neoclide/coc.nvim'

call plug#end()
```
On a neovim instance install it with:

```bash
:PlugInstall
```
Install nodejs and npm
```bash
sudo pacman -S nodejs npm
```
Navigate to the coc.nvim directory (~/.local/share/nvim/plugged/coc.nvim) and install yarn:
```bash
sudo npm install -g yarn
```
```bash
yarn install
```
```bash
yarn build
```

**The following are instructions for python:**

On a terminal install pip if you dont have it already:

```bash
sudo pacman -S python-pip
```

Install jedi:

```bash
sudo pacman -S python-jedi
```
In a neovim instance install coc-python:

```bash
:CocInstall coc-python
```

**The following are instructions for C**

On a terminal:
```bash
sudo pacman -S clang
```
In a neovim instance:

```bash
CocInstall coc-clangd
```

If you get an error while openning a C file, try:

```bash
:CocCommand clang.install
```
