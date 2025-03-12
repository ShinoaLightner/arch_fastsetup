#!/bin/bash

# Select video driver
echo "Select your GPU driver:"
echo "1) NVIDIA"
echo "2) Intel"
echo "3) AMD"
read -p "Enter the number (1-3): " gpu_choice

case $gpu_choice in
    1) video_driver="nvidia-open nvidia-utils nvidia-settings" ;;
    2) video_driver="mesa xf86-video-intel" ;;
    3) video_driver="mesa xf86-video-amdgpu" ;;
    *) echo "Invalid choice. Defaulting to No Graphic Driver."; video_driver="" ;;
esac


echo "### Installing the base system..."
pacstrap -K /mnt base linux linux-firmware networkmanager pipewire pipewire-pulse grub efibootmgr alacritty bspwm sxhkd rofi polybar dunst picom sddm nano discord firefox sudo git $video_driver feh ttf-jetbrains-mono-nerd ttf-jetbrains-mono
echo "✅ Base system installed!"
read -p "Press [Enter] to continue..."

echo "### Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab
echo "✅ fstab generated!"
read -p "Press [Enter] to continue..."

mv 2_after_arch_chroot.sh /mnt/after_arch_chroot.sh
