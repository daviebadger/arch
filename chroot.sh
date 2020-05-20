#!/bin/bash
#
# Install the system.

ln -sf /usr/share/zoneinfo/Europe/Prague /etc/localtime
hwclock --systohc

sed -i "s/#cs_CZ.UTF-8/cs_CZ.UTF-8/" /etc/locale.gen
sed -i "s/#en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen

locale-gen
