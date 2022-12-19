#!/bin/bash

trap "exit 1" 1 2 3 SIGTRAP 6 14 15

uefiBootConfig() {
	pacman -S --noconfirm grub efibootmgr "${cpuVendor:?}-ucode" || return 1
    grub-install --target=x86_64-efi --efi-directory=esp --bootloader-id=GRUB

    sed -i "s+\${grub_probe} --device \${GRUB_DEVICE} --target=fs_label 2>/dev/null || true+zdb -l \${GRUB_DEVICE} | grep \" name:\" | cut -d\' -f2+"
    grub-mkconfig -o /boot/grub/grub.cfg || return 1
}

biosBootConfig() {
    pacman -S --noconfirm grub "${cpuVendor:?}-ucode" || return 1
    grub-install --target=i386-pc "${DRIVE:?}" || return 1

    sed -i "s+\${grub_probe} --device \${GRUB_DEVICE} --target=fs_label 2>/dev/null || true+zdb -l \${GRUB_DEVICE} | grep \" name:\" | cut -d\' -f2+"
    grub-mkconfig -o /boot/grub/grub.cfg || return 1
}

# Determine CPU vendor for microcode package
case $(lscpu | grep ^Vendor | awk '{print $3}') in
    'GenuineIntel')     cpuVendor='intel' ;;
    'AuthenticAMD')     cpuVendor='amd' ;;
esac

# Run the appropriate function, based on boot mode
case ${BOOTMODE:?} in
    'UEFI')
        uefiBootConfig || exit 1 ;;
    'BIOS')
        biosBootConfig || exit 1 ;;
esac
