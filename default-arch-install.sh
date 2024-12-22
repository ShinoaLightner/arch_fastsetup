timedatectl set-timezone Europe/Kyiv

echo "Доступные диски:"
fdisk -l | grep -E "Disk /dev/"

echo -n "Введите диск для установки (например, /dev/nvme0n1): "
read disk

if [ ! -b "$disk" ]; then
    echo "Ошибка: Диск $disk не найден!"
    exit 1
fi

echo "ВНИМАНИЕ: Все данные на $disk будут удалены!"
echo -n "Продолжить? (y/n): "
read confirm
if [[ "$confirm" != "y" ]]; then
    echo "Операция отменена."
    exit 0
fi

(
echo o
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

echo w
) | fdisk "$disk"

mkfs.fat -F32 "${disk}1" # EFI
mkswap "${disk}2"        # SWAP
swapon "${disk}2"        # Активировать SWAP
mkfs.ext4 "${disk}3"     # ROOT