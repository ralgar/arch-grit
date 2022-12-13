#!/bin/bash


trap "exit 1" 1 2 3 SIGTRAP 6 14 15

# Configure and generate the initramfs
sed -i "s/^HOOKS=.*/HOOKS=(base systemd sd-plymouth keyboard autodetect sd-vconsole modconf block sd-encrypt filesystems btrfs fsck)/" /etc/mkinitcpio.conf || exit 1
plymouth-set-default-theme -R arch-logo-new || exit 1


exit 0
