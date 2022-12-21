#######################################
###   LIBRARY - MOUNT FILESYSTEMS   ###
#######################################
mountFilesystems() {

    # Important: Re-import the pool after prior export
    zpool import -d /dev/disk/by-partlabel -R /mnt zroot -N || return 1

    zfs load-key -a <<<"${CRYPTPASS:?}" || return 1
    # Manually mount the root dataset because it uses canmount=noauto
    zfs mount zroot/ROOT/default || return 1
    zfs mount -a || return 1

    # Mount the boot partition
    mkdir /mnt/boot || return 1
    if [[ ${BOOTMODE:?} = UEFI ]] ; then
        mount LABEL=EFI /mnt/boot || return 1
    elif [[ ${BOOTMODE:?} = BIOS ]] ; then
        mount LABEL=BOOT /mnt/boot || return 1
    fi
}
