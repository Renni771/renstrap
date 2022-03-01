# renstrap
These are some scripts to automate Arch Linux install process based entirely on my own preference.

## Background
I wanted to learn more about Arch Linux, Linux in general and shell scripting, so this project helped me do that :).
I also do intent to use these scripts productively and hope to improve on them whenever I have time.

## Usage
Enable execution with `chmod +x ./<script-name>`. Make sure you check the scripts before running them and feel
free to edit them to suit your specific needs.

## renstrap-base-uefi 🤖
This script assumes you have separate `root` and `home` directories and that you have a `swap` directory.

Create your `boot`, `swap`, `root` and `home` partitions and specifiy their locations to the script. For help use `./renstrap-base-uefi -h`.

## renstrap-system 🧑‍🔬
Bootstrap a base Arch Linux install. After an `arch-chroot /mnt`, clone this repo into into your `/tmp` directory so it doesn't lay around.

## renstrap-user 🚀
This bootstraps a user with the basic tools I use in my daily workflow.

## "renstap"? 🤌
(pac)man + boot(strap) = pacstrap => (ren)dani + boot(strap) = renstrap. Its like pacstrap but with more "ren".

