#!/bin/bash

echo "### Installing the base system..."
pacstrap -K /mnt base linux linux-firmware networkmanager pulseaudio pipewire-pulse grub efibootmgr alacritty bspwm rofi polybar dunst picom sddm nano discord
echo "✅ Base system installed!"
read -p "Press [Enter] to continue..."

echo "### Generating fstab..."
genfstab -U /mnt >> /mnt/etc/fstab
echo "✅ fstab generated!"
read -p "Press [Enter] to continue..."

echo "### Entering the new system..."
arch-chroot /mnt <<EOF

echo "### Setting up the time zone..."
ln -sf /usr/share/zoneinfo/Europe/Kyiv /etc/localtime
hwclock --systohc
echo "✅ Time zone configured!"
read -p "Press [Enter] to continue..."

echo "### Configuring locale..."
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "uk_UA.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=uk_UA.UTF-8" > /etc/locale.conf
echo "KEYMAP=us" > /etc/vconsole.conf
echo "✅ Locale configured!"
read -p "Press [Enter] to continue..."

echo "### Installing GRUB..."
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
echo "✅ GRUB installed!"
read -p "Press [Enter] to continue..."

echo "### Creating a user..."
useradd -m -G wheel -s /bin/bash user
echo "user:password" | chpasswd
echo "user ALL=(ALL) ALL" >> /etc/sudoers
echo "✅ User 'user' created!"
read -p "Press [Enter] to continue..."

echo "### Enabling services..."
systemctl enable NetworkManager
systemctl enable sddm
echo "✅ Services enabled!"
read -p "Press [Enter] to continue..."

EOF

echo "### Exiting chroot..."
read -p "Press [Enter] to continue..."

echo "### Unmounting partitions..."
umount -R /mnt
echo "✅ Partitions unmounted!"
read -p "Press [Enter] to reboot..."

echo "### Rebooting..."
reboot
