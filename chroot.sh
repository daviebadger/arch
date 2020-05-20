#!/bin/bash
#
# Install the system.

ln -sf /usr/share/zoneinfo/Europe/Prague /etc/localtime
hwclock --systohc

sed -i "s/#cs_CZ.UTF-8/cs_CZ.UTF-8/" /etc/locale.gen
sed -i "s/#en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen

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
