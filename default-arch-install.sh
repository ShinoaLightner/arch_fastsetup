#!/bin/bash

# Set timezone
timedatectl set-timezone Europe/Kyiv

# Display available disks
echo "Available disks:"
fdisk -l | grep -E "Disk /dev/"


echo -n "Enter the disk for installation (e.g., /dev/nvme0n1): "
read disk


if [ ! -b "$disk" ]; then
    echo "Error: Disk $disk not found!"
    exit 1
fi


echo "WARNING: All data on $disk will be erased!"
echo -n "Do you want to proceed? (y/n): "
read confirm
if [[ "$confirm" != "y" ]]; then
    echo "Operation canceled."
    exit 0
fi


(
echo g
echo n
echo
echo
echo +512M
echo t
echo 1

echo n
echo
echo
echo +4G
echo t
echo 2
echo 19

echo n
echo
echo
echo
echo t
echo 3

echo w # Write changes
) | fdisk "$disk"

# Format partitions
mkfs.fat -F32 "${disk}1" # Format EFI partition
mkswap "${disk}2"        # Create swap
swapon "${disk}2"        # Activate swap
mkfs.ext4 "${disk}3"     # Format root partition

echo "Partitioning and formatting completed successfully."
