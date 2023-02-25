#!/bin/bash

trap "exit 1" 1 2 3 SIGTRAP 6 14 15

uefiBootConfig() {
    grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB || return 1

    cmdline_key="GRUB_CMDLINE_LINUX_DEFAULT" || return 1
    if [[ ${VDRV:?} == "NVIDIA Proprietary" ]] ; then
        cmdline_val="quiet splash loglevel=3 nvidia_drm.modeset=1" || return 1
    else
        cmdline_val="quiet splash loglevel=3" || return 1
    fi

    sed -i "s/^$cmdline_key.*$/$cmdline_key=\"$cmdline_val\"/" /etc/default/grub || return 1
    sed -i "s+\${grub_probe} --device \${GRUB_DEVICE} --target=fs_label 2>/dev/null || true+zdb -l \${GRUB_DEVICE} | grep \" name:\" | cut -d\\\' -f2+" /etc/grub.d/10_linux || return 1
    grub-mkconfig -o /boot/grub/grub.cfg || return 1
}

biosBootConfig() {
    grub-install --target=i386-pc "${DRIVE:?}" || return 1

    cmdline_key="GRUB_CMDLINE_LINUX_DEFAULT" || return 1
    if [[ ${VDRV:?} == "NVIDIA Proprietary" ]] ; then
        cmdline_val="quiet splash loglevel=3 nvidia_drm.modeset=1" || return 1
    else
        cmdline_val="quiet splash loglevel=3" || return 1
    fi

    sed -i "s/^$cmdline_key.*$/$cmdline_key=\"$cmdline_val\"/" /etc/default/grub || return 1
    sed -i "s+\${grub_probe} --device \${GRUB_DEVICE} --target=fs_label 2>/dev/null || true+zdb -l \${GRUB_DEVICE} | grep \" name:\" | cut -d\\\' -f2+" /etc/grub.d/10_linux || return 1
    grub-mkconfig -o /boot/grub/grub.cfg || return 1
}

# Run the appropriate function, based on boot mode
case ${BOOTMODE:?} in
    'UEFI')
        uefiBootConfig || exit 1 ;;
    'BIOS')
        biosBootConfig || exit 1 ;;
esac
