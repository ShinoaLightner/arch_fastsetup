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

echo w # Write changes
) | fdisk "$disk"

partition_list=$(lsblk -ln -o NAME -r "/dev/sda" | grep -E "^$(basename "/dev/sda")" | awk '{print "/dev/" $1}')

# Format partitions
mkfs.fat -F32 "${partition_list[0]}" # Format EFI partition
mkswap "${partition_list[1]}"        # Create swap
swapon "${partition_list[1]}"        # Activate swap
mkfs.ext4 "${partition_list[2]}"     # Format root partition

echo "Partitioning and formatting completed successfully."
