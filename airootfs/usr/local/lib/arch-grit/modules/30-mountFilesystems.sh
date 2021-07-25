#######################################
###   LIBRARY - MOUNT FILESYSTEMS   ###
#######################################
mountFilesystems() {
    # Set variables for mount options
    local o_btrfs='defaults,x-mount.mkdir,compress-force=zstd,noatime'

    # Mount the decrypted partition, create new subvolumes, and unmount
    mount -t btrfs LABEL=system /mnt || return 1
    btrfs subvolume create /mnt/@ || return 1
    btrfs subvolume create /mnt/@home || return 1
    btrfs subvolume create /mnt/@snapshots || return 1
    btrfs subvolume create /mnt/@swap || return 1
    umount -R /mnt || return 1

    # Now mount ONLY the subvolumes
    mount -t btrfs -o subvol=@,"$o_btrfs" LABEL=system /mnt || return 1
    mount -t btrfs -o subvol=@home,"$o_btrfs" LABEL=system /mnt/home || return 1
    mount -t btrfs -o subvol=@snapshots,"$o_btrfs" LABEL=system /mnt/.snapshots || return 1
    mount -t btrfs -o subvol=@swap,"$o_btrfs" LABEL=system /mnt/.swap || return 1

    # Init swapfile
    export swapFile='/mnt/.swap/file'
    swapSize=$(((($(free -m | grep Mem | awk '{ print $2 }') / 1000) + 1) * 1024))
    truncate -s 0 "$swapFile" || return 1
    chattr +C "$swapFile" || return 1
    btrfs property set "$swapFile" compression none || return 1
    dd if=/dev/zero of="$swapFile" bs=1M count="$swapSize" || return 1
    chmod 600 "$swapFile" || return 1
    mkswap "$swapFile" || return 1
    umount /mnt/.swap || return 1

    # Create "nested" subvolumes
    mkdir -p /mnt/var/cache/pacman || return 1
    btrfs subvolume create /mnt/var/cache/pacman/pkg || return 1
    btrfs subvolume create /mnt/var/log || return 1

    # Mount the boot partition
    mkdir /mnt/boot || return 1
    if [[ ${BOOTMODE:?} = UEFI ]] ; then
        mount LABEL=EFI /mnt/boot || return 1
    elif [[ ${BOOTMODE:?} = BIOS ]] ; then
        mount LABEL=BOOT /mnt/boot || return 1
    fi
}
