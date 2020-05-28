#!/bin/bash
#
# Install the system.

ln --force --symbolic /usr/share/zoneinfo/Europe/Prague /etc/localtime
hwclock --systohc

sed --in-place "s/#cs_CZ.UTF-8/cs_CZ.UTF-8/" /etc/locale.gen
sed --in-place "s/#en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen

locale-gen

cat << EOF > /etc/locale.conf
LANG=en_US.UTF-8
LC_ADDRESS=cs_CZ.UTF-8
LC_IDENTIFICATION=cs_CZ.UTF-8
LC_MEASUREMENT=cs_CZ.UTF-8
LC_MONETARY=cs_CZ.UTF-8
LC_NAME=cs_CZ.UTF-8
LC_NUMERIC=cs_CZ.UTF-8
LC_PAPER=cs_CZ.UTF-8
LC_TELEPHONE=cs_CZ.UTF-8
LC_TIME=cs_CZ.UTF-8
EOF

cat << EOF > /etc/vconsole.conf
FONT=eurlatgr
KEYMAP=cz
EOF

HOSTNAME="badger"

echo "${HOSTNAME}" > /etc/hostname
echo >> /etc/hosts

cat << EOF >> /etc/hosts
127.0.0.1	localhost
127.0.1.1	$HOSTNAME.localdomain	$HOSTNAME

::1		    localhost
EOF

pacman -S --noconfirm dhcpcd
systemctl enable dhcpcd

passwd

USER="davie"

useradd --create-home "${USER}"
passwd "${USER}"
usermod --append --groups=audio,optical,storage,video,wheel "${USER}"

pacman -S --noconfirm sudo
sed --in-place "s/# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/" /etc/sudoers
visudo --check --file=/etc/sudoers
