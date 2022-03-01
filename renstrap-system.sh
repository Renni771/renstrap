#!/bin/bash

function print () {
  printf "\e[1;32m $1 \e[0m"
}

# Setup locale
read -p "What is your locale? (e.g en_ZA or en_US) " LOCALE
LOCALE="$LOCALE.UTF-8 UTF-8"
sed -i "s/\#$LOCALE/$LOCALE/" /etc/locale.gen
locale-gen
echo LANG=en_ZA.UTF-8 > /etc/locale.conf
export LANG=en_ZA.UTF-8

# Setup time
ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime
hwclock --systohc

# Setup hostname
clear
read -p "What would you like your computer hostname to be? " HOSTNAME
echo $HOSTNAME > /etc/hostname

# Enable multilib
# WARNING: Sketchy
PACMAN_CONFIG=/etc/pacman.conf
echo "" >> $PACMAN_CONFIG
echo "[multilib]" >> $PACMAN_CONFIG
echo "Include = /etc/pacman.d/mirrorlist" >> $PACMAN_CONFIG

# Download base packages
pacman -Syy --noconfirm networkmanager neovim vim base-devel intel-ucode xdg-utils xdg-user-dirs

# Boot boot loader
mount -t efivarfs efivarfs /sys/firmware/efi/efivars/
bootctl install
BOOT_LOADER_CONFIG_PATH=/boot/loader/entries/default.conf
clear
read -p "What would you like your boot title to be?" BOOT_NAME
cat > $BOOT_LOADER_CONFIG_PATH << "EOF"
title $BOOT_NAME
linux /vmlinuz-linux
initrd /intel-ucode.img
initrd /initramfs-linux.img
EOF

# Secure boot drive
clear
echo " " && lsblk && echo " "
read -p "What partition is your root mounted to (enter sdX)? " ROOT_PARTITION_NAME
echo "options root=PARTUUID=$(blkid -s PARTUUID -o value /dev/$ROOT_PARTITION_NAME) rw" >> $BOOT_LOADER_CONFIG_PATH

echo " " && echo "Please set a root password:"
passwd

# Add base user
clear
read -p "What would you like your main username to be? " USERNAME
useradd -m -g users -G wheel,storage,power -s /bin/bash $USERNAME
echo " " && echo "Please set your main user password: "
passwd $USERNAME

SODOERS_FILE="/etc/sudoers"
sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' $SODOERS_FILE
echo >> $SODOERS_FILE
echo "Defaults rootpw" >> $SODOERS_FILE

# Enable system services
systemctl enable NetworkManager
systemctl enable fstrim.timer

# Update everything
pacman -Syu --noconfirm

print "Arch base setup done!"

exit 1;
