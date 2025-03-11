#!/bin/bash

pacstrap -K /mnt base linux linux-firmware networkmanager pulseaudio pipewire-pulse grub efibootmgr alacritty bspwm rofi polybar dunst picom sddm nano discord

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt <<EOF

ln -sf /usr/share/zoneinfo/Europe/Kyiv /etc/localtime
hwclock --systohc

echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "uk_UA.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=uk_UA.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

useradd -m -G wheel -s /bin/bash user
echo "user:password" | chpasswd
echo "user ALL=(ALL) ALL" >> /etc/sudoers

systemctl enable NetworkManager
systemctl enable sddm

EOF

umount -R /mnt
reboot