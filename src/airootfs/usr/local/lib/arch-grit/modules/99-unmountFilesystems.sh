#########################################
###   LIBRARY - UNMOUNT FILESYSTEMS   ###
#########################################
unmountFilesystems() {
    # Remove installation files from new system
    rm -rf "/mnt/${libPath:?}" || return 1

    # Sync and unmount all filesystems to complete installation
    sync || return 1
    umount /mnt/boot || return 1
    zfs umount -a || return 1
    zpool export zroot || return 1
}
