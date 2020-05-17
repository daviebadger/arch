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
