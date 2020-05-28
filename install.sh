#!/bin/bash
#
# Install Arch Linux.

set -eu -o pipefail

loadkeys cz
setfont -h20 eurlatgr

ip link
ping -c 1 archlinux.org

timedatectl set-ntp true
timedatectl set-timezone Europe/Prague

DISK="/dev/$(lsblk | awk '/disk/ {print $1}')"
MEMORY_GB="$(free --giga | awk '/Mem:/ {print $2}')"

if ls /sys/firmware/efi/efivars; then
  SWAP_PARTITION_END_MIB="$((261 + "${MEMORY_GB}" * 1000))Mib"

  PARTED_COMMANDS=(
    "mklabel gpt"
    "mkpart primary fat32 1Mib 261Mib"
    "set 1 esp on"
    "mkpart primary linux-swap 261Mib ${SWAP_PARTITION_END_MIB}"
    "mkpart primary ext4 ${SWAP_PARTITION_END_MIB} 100%"
  )

  for parted_command in "${PARTED_COMMANDS[@]}"; do
    parted --script "${DISK}" "${parted_command}"
  done

  EFI_PARTITION="${DISK}1"

  mkfs.fat -F 32 "${EFI_PARTITION}"

  SWAP_PARTITION="${DISK}2"

  mkswap "${SWAP_PARTITION}"
  swapon "${SWAP_PARTITION}"

  ROOT_PARTITION="${DISK}3"

  mkfs.ext4 "${ROOT_PARTITION}"

  mount "${ROOT_PARTITION}" /mnt
  mkdir /mnt/efi
  mount "${EFI_PARTITION}" /mnt/efi
else
  SWAP_PARTITION_END_MIB="$((1 + "${MEMORY_GB}" * 1000))Mib"

  PARTED_COMMANDS=(
    "mklabel msdos"
    "mkpart primary linux-swap 1Mib ${SWAP_PARTITION_END_MIB}"
    "mkpart primary ext4 ${SWAP_PARTITION_END_MIB} 100%"
    "set 2 boot on"
  )

  for parted_command in "${PARTED_COMMANDS[@]}"; do
    parted --script "${DISK}" "${parted_command}"
  done

  SWAP_PARTITION="${DISK}1"

  mkswap "${SWAP_PARTITION}"
  swapon "${SWAP_PARTITION}"

  ROOT_PARTITION="${DISK}2"

  mkfs.ext4 "${ROOT_PARTITION}"

  mount "${ROOT_PARTITION}" /mnt
fi

pacstrap /mnt base base-devel linux linux-firmware

genfstab -U /mnt >> /mnt/etc/fstab

wget --directory-prefix=/mnt https://raw.githubusercontent.com/daviebadger/arch/master/chroot.sh

arch-chroot /mnt chmod +x chroot.sh
arch-chroot /mnt ./chroot.sh
arch-chroot /mnt rm chroot.sh

# umount --recursive /mnt
#
# reboot
