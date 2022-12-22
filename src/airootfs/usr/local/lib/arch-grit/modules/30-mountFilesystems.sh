#######################################
###   LIBRARY - MOUNT FILESYSTEMS   ###
#######################################
mountFilesystems() {

    # Important: Re-import the pool after prior export
    zpool import -d /dev/disk/by-partlabel -R /mnt zroot -N || return 1

    zfs load-key zroot <<<"${CRYPTPASS:?}" || return 1
    # Manually mount the root dataset because it uses canmount=noauto
    zfs mount zroot/ROOT/default || return 1
    zfs mount -a || return 1

    # Configure the root filesystem
    zpool set bootfs=zroot/ROOT/default zroot
    zpool set cachefile=/etc/zfs/zroot.cache zroot
    mkdir -p /mnt/etc/zfs || return 1
    cp /etc/zfs/zroot.cache /mnt/etc/zfs/zroot.cache

    # Mount the boot partition
    mkdir /mnt/boot || return 1
    if [[ ${BOOTMODE:?} = UEFI ]] ; then
        mount LABEL=EFI /mnt/boot || return 1
    elif [[ ${BOOTMODE:?} = BIOS ]] ; then
        mount LABEL=BOOT /mnt/boot || return 1
    fi
}
