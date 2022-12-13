#!/bin/bash

trap "exit 1" 1 2 3 SIGTRAP 6 14 15

uefiBootConfig() {
    local partUUID
    local bootParams

    partUUID=$(lsblk -fs | grep "${DRIVE:5}"2 | awk '{ print $4 }') || return 1
    bootParams="rd.luks.name=${partUUID:?}=cryptsystem" || return 1
    bootParams+=" root=UUID=${subvolUUID:?} rootflags=subvol=@" || return 1

	  pacman -S --noconfirm refind "${cpuVendor:?}-ucode" || return 1
    if [[ ${DRIVE:?} == *"nvme"* ]] ; then
	      refind-install --usedefault "${DRIVE:?}p1" --alldrivers || return 1
    else
	      refind-install --usedefault "${DRIVE:?}1" --alldrivers || return 1
    fi

    cat << EOF > /boot/refind_linux.conf
"Boot using default options" "$kernelCmdSplash ${bootParams:?} rw initrd=/${cpuVendor:?}-ucode.img initrd=/initramfs-%v.img"
"Boot using fallback initramfs" "$kernelCmdSplash ${bootParams:?} rw initrd=/${cpuVendor:?}-ucode.img initrd=/initramfs-%v-fallback.img"
"Boot to terminal" "${bootParams:?} rw initrd=/${cpuVendor:?}-ucode.img initrd=/initramfs-%v.img systemd.unit=multi-user.target"
EOF
}

biosBootConfig() {
    local partUUID
    local bootParams

    partUUID=$(lsblk -fs | grep "${DRIVE:5}"3 | awk '{ print $4 }')
    bootParams="rd.luks.name=${partUUID:?}=cryptsystem"
    bootParams+=" root=UUID=${subvolUUID:?} rootflags=subvol=@"

    pacman -S --noconfirm grub "${cpuVendor:?}-ucode" || return 1
    grub-install --target=i386-pc "${DRIVE:?}" || return 1
    sed -i "s/CMDLINE_LINUX=.*/CMDLINE_LINUX=\"$bootParams\"/" \
        /etc/default/grub || return 1
	  sed -i "s/LINUX_DEFAULT=.*/LINUX_DEFAULT=\"$kernelCmdSplash\"/" \
        /etc/default/grub || return 1
    sed -i "s/^#GRUB_DISABLE_LINUX_UUID=true/GRUB_DISABLE_LINUX_UUID=true/" \
        /etc/default/grub || return 1
    grub-mkconfig -o /boot/grub/grub.cfg || return 1
}

# Determine CPU vendor for microcode package
case $(lscpu | grep ^Vendor | awk '{print $3}') in
    'GenuineIntel')     cpuVendor='intel' ;;
    'AuthenticAMD')     cpuVendor='amd' ;;
esac

# Get UUID's and run the appropriate function, based on boot mode
kernelCmdSplash='quiet splash loglevel=3 rd.systemd.show_status=auto rd.udev.log_priority=3'
subvolUUID=$(btrfs filesystem show system | grep Label | awk '{ print $4 }')
case ${BOOTMODE:?} in
    'UEFI')
        uefiBootConfig || exit 1 ;;
    'BIOS')
        biosBootConfig || exit 1 ;;
esac
