#!/bin/bash

#TODO: automatically partition disks

BOOT_PARTITION=""
SWAP_PARTITION=""
ROOT_PARTITION=""
HOME_PARTITION=""

function main {
  parseArgs $@

  if [[ ! -n "$BOOT_PARTITION" ]]; then print "No boot partition specified.\n" && abort; fi
  if [[ ! -n "$SWAP_PARTITION" ]]; then print "No swap partition specified.\n" && abort; fi
  if [[ ! -n "$ROOT_PARTITION" ]]; then print "No root partition specified.\n" && abort; fi
  if [[ ! -n "$HOME_PARTITION" ]]; then print "No home partition specified.\n" && abort; fi

  print "Creating partitions for: \n"
  echo "[boot] - $BOOT_PARTITION"
  echo "[swap] - $SWAP_PARTITION"
  echo "[root] - $ROOT_PARTITION"
  echo "[homt] - $HOME_PARTITION"

  # Make file systems
  mkfs.fat -F32 $BOOT_PARTITION
  mkswap $SWAP_PARTITION && swapon $SWAP_PARTITION
  mkfs.ext4 $ROOT_PARTITION && mkfs.ext4 $HOME_PARTITION

  # Mount partitions
  mount $ROOT_PARTITION /mnt
  mkdir /mnt/{boot,home}
  mount $HOME_PARTITION /mnt/home
  mount $BOOT_PARTITION /mnt/boot

  # Get good mirrors
  cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
  pacman -Syy --noconfirm pacman-contrib
  rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist

  # TO THE MOON!!!
  pacstrap -i /mnt base base-devel linux linux-firmware linux-headers vim bash-completion git

  # Generate file system table
  genfstab -U /mnt >> /mnt/etc/fstab

  echo " "
  print "Base install completed :) . Changing root to your install in 3 seconds..."
  echo " "
  sleep 3
  arch-chroot /mnt
}

function parseArgs () {
  while test $# -gt 0; do
    case "$1" in
      --help) showHelp && exit 0 ;;
      -b | --boot) shift && BOOT_PARTITION=/dev/$1 && shift ;;
      -s | --swap) shift && SWAP_PARTITION=/dev/$1 && shift ;;
      -r | --root) shift && ROOT_PARTITION=/dev/$1 && shift ;;
      -h | --home) shift && HOME_PARTITION=/dev/$1 && shift ;;
      *) break ;;
    esac
  done
}

function showHelp () {
  echo "Install the Arch Linux base given a disk partition scheme."
  echo " "
  echo "Please give partition sdXY:"
  echo "X = the device letter."
  echo "Y = the device number."
  echo " "
  echo "options:"
  echo "-h, --help           show brief help"
  echo "-b, --boot=sdX       the boot partition"
  echo "-s, --swap=sdX       the swap partition"
  echo "-r, --root=sdX       the root partiton"
  echo "-h, --home=sdX       the home partition"
}

function abort () {
  showHelp
  exit 0;
}

function print () {
  printf "\e[1;32m $1 \e[0m"
}

main $@
