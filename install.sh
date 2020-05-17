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

ROOT_PARTITION="${DISK}3"

mkfs.ext4 "${ROOT_PARTITION}"

SWAP_PARTITION="${DISK}2"

mkswap "${SWAP_PARTITION}"
swapon "${SWAP_PARTITION}"
