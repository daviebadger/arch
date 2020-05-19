#!/bin/bash
#
# Install the system.

ln -sf /usr/share/zoneinfo/Europe/Prague /etc/localtime
hwclock --systohc
