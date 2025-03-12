#!/bin/bash

echo "### Installing the base system..."
pacstrap -K /mnt base linux linux-firmware networkmanager pipewire pipewire-pulse grub efibootmgr alacritty bspwm rofi polybar dunst picom sddm nano discord firefox sudo
echo "✅ Base system installed!"
read -p "Press [Enter] to continue..."

echo "### Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab
echo "✅ fstab generated!"
read -p "Press [Enter] to continue..."

mv after_arch_chroot.sh /mnt/after_arch_chroot.sh
