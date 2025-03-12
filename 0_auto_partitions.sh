#!/bin/bash

# Set timezone
timedatectl set-timezone Europe/Kyiv

# Display available disks
echo "Available disks:"
lsblk -dpno NAME,SIZE | grep -E "/dev/(sd|nvme|vd)"

# Ask the user for the installation disk
echo -n "Enter the disk for installation (e.g., /dev/nvme0n1): "
read disk

# Check if the entered disk exists
if [ ! -b "$disk" ]; then
    echo "Error: Disk $disk not found!"
    exit 1
fi

# Warn the user that all data will be erased
echo "WARNING: All data on $disk will be erased!"
echo -n "Do you want to proceed? (y/n): "
read confirm
if [[ "$confirm" != "y" ]]; then
    echo "Operation canceled."
    exit 0
fi

# Create a new partition table and partitions
(
echo g         # Create a GPT partition table
echo n         # Create a new partition (EFI)
echo           # Default partition number (1)
echo           # Default first sector
echo +1G     # 1G size
echo t         # Change partition type
echo 1         # Set type to EFI System

echo n         # Create a new partition (SWAP)
echo           # Default partition number (2)
echo           # Default first sector
echo +4G       # 4GB size
echo t         # Change partition type
echo 2         # Select the second partition
echo 19        # Set type to Linux swap

echo n         # Create a new partition (ROOT)
echo           # Default partition number (3)
echo           # Default first sector
echo           # Use the remaining space
echo t         # Change partition type
echo 3         # Select the third partition
echo 20        # Set type to Linux Filesystem

echo w         # Write changes to disk
) | fdisk "$disk"

# Define partition names based on disk type
part1="${disk}p1"
part2="${disk}p2"
part3="${disk}p3"

# Adjust partition names for SATA disks (sdaX format)
if [[ "$disk" =~ "/dev/sd" ]]; then
    part1="${disk}1"
    part2="${disk}2"
    part3="${disk}3"
fi

# Format partitions
mkfs.fat -F32 "$part1"   # Format EFI partition as FAT32
mkswap "$part2"          # Create swap partition
swapon "$part2"          # Enable swap
mkfs.ext4 "$part3"       # Format root partition as ext4

# Mount the root partition
mount "$part3" /mnt
mkdir -p /mnt/boot       # Create boot directory if it doesn't exist
mount "$part1" /mnt/boot # Mount EFI partition

echo "✅ Partitioning and formatting completed successfully."
