#!/bin/bash

cd ~

# Setup Display manager and, WM/DE
sudo pacman -Syy --noconfirm xorg gnome gdm # gnome just for now
sudo systemctl enable gdm

# Graphics
# pacman -S --noconfirm nvidia nvidia-utils nvidia-settings
# pacman -S --noconfirm xf86-video-amdgpu

# Install yay
git clone https://aur.archlinux.org/yay.git
cd yay && makepkg -si
cd .. && rm -rf yay

# Install base packages
sudo pacman -Syy --nocomfirm alacritty tmux neovim vlc youtube-dl lxappearance qt5-base zsh zsh-completions
yay -Syy --noconfirm brave-bin spotify timeshift ttf-meslo-nerd-font-powerlevel10k

# NOTE: Install fallback terminal becuase of graphical issues with alacritty in VMs etc.
sudo pacman -S --noconfirm konsole

# Get dotfiles
DOTFILES_REPO="https://github.com/Renni771/dotfiles"
DOTFILES_PATH=~/dotfiles
cd ~ && git clone $DOTFILES_REPO
ln -s "$DOTFILES_PATH/.config/nvim" ~/.config/nvim
ln -s "$DOTFILES_PATH/.config/alacritty" ~/.config/alacritty
ln -s "$DOTFILES_PATH/.tmux.conf" ~/.tmux.conf

# Vim plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Misc.
echo "alias vi=vim" >> ~/.bashrc
echo "alias vim=nvim" >> ~/.bashrc

# Zsh setup
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
