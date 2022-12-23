############################
### GENERATE THE FSTAB   ###
############################
generateFstab() {

    # Configure ZFS on new root
    zpool set bootfs=zroot/ROOT/default zroot
    [[ -f /etc/zfs/zpool.cache ]] || zpool set cachefile=/etc/zfs/zpool.cache zroot
    cp /etc/zfs/zpool.cache /mnt/etc/zfs/zpool.cache

    genfstab -f /mnt/boot -U /mnt > /mnt/etc/fstab
}
