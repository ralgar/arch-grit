#######################################
###   LIBRARY - FORMAT PARTITIONS   ###
#######################################
formatPartitions() {
    # Wait until udev updates the partlabels (required)
    until [[ -e /dev/disk/by-partlabel/cryptsystem ]] ; do
        sleep 1
    done
    sleep 5

    modprobe zfs || return 1

    zpool create -f -o ashift=12       \
             -O acltype=posixacl       \
             -O atime=off              \
             -O xattr=sa               \
             -O dnodesize=legacy       \
             -O normalization=formD    \
             -O mountpoint=none        \
             -O canmount=off           \
             -O devices=off            \
             -R /mnt                   \
             -O compression=lz4        \
             -O encryption=aes-256-gcm \
             -O keyformat=passphrase   \
             -O keylocation=prompt     \
             zroot /dev/disk/by-partlabel/cryptsystem

    zfs create -o mountpoint=none zroot/ROOT
    zfs create -o mountpoint=/ -o canmount=noauto zroot/ROOT/default

    zfs create -o mountpoint=none zroot/data
    zfs create -o mountpoint=/home zroot/data/home
    zfs create -o mountpoint=/root zroot/data/home/root

    zfs create -o mountpoint=/var -o canmount=off     zroot/var
    zfs create                                        zroot/var/log
    zfs create -o mountpoint=/var/lib -o canmount=off zroot/var/lib
    zfs create                                        zroot/var/lib/containers
    zfs create                                        zroot/var/lib/docker
    zfs create                                        zroot/var/lib/libvirt

    # Important: Export the pool
    zpool export zroot

    # Format the BOOT partition to fat32
    if [[ ${BOOTMODE:?} = UEFI ]] ; then
        mkfs.fat -F32 -n EFI /dev/disk/by-partlabel/EFI || return 1
    else
        mkfs.fat -F32 -n BOOT /dev/disk/by-partlabel/BOOT || return 1
    fi
}
