#!/bin/bash

echo "### Setting up the time zone..."
ln -sf /usr/share/zoneinfo/Europe/Kyiv /etc/localtime
hwclock --systohc
echo "✅ Time zone configured!"
read -p "Press [Enter] to continue..."

echo "### Configuring locale..."
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
echo "uk_UA.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf
echo "✅ Locale configured!"
read -p "Press [Enter] to continue..."

echo "### Installing GRUB..."
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=Arch
grub-mkconfig -o /boot/grub/grub.cfg
echo "✅ GRUB installed!"
read -p "Press [Enter] to continue..."

echo "### Creating a user..."
read -p "Enter username: " username
useradd -m -G wheel -s /bin/bash "$username"

read -sp "Enter password for $username: " password
echo

echo "$username:$password" | chpasswd
echo "$username ALL=(ALL) ALL" >> /etc/sudoers

echo "✅ User '$username' created!"
read -p "Press [Enter] to continue..."


echo "### Enabling services..."
systemctl enable NetworkManager
systemctl enable sddm
echo "✅ Services enabled!"
read -p "Press [Enter] to continue..."

mkdir -p /home/$username/.config/bspwm/
mkdir -p /home/$username/.config/sxhkd/
mkdir -p /home/$username/.config/polybar/

chown -hR ether /home/$username/.config
