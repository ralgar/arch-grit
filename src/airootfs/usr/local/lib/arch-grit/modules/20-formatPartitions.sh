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

    # autotrim=on

    zpool create -f -o ashift=12  \
        -O acltype=posixacl       \
        -O atime=off              \
        -O autotrim=on            \
        -O xattr=sa               \
        -O dnodesize=legacy       \
        -O normalization=formD    \
        -O mountpoint=none        \
        -O canmount=off           \
        -O devices=off            \
        -O compression=lz4        \
        -O encryption=aes-256-gcm \
        -O keyformat=passphrase   \
        -O keylocation=prompt     \
        -R /mnt                   \
        zroot /dev/disk/by-partlabel/cryptsystem <<<"${CRYPTPASS:?}" || return 1

    zfs create -o mountpoint=none zroot/ROOT || return 1
    zfs create -o mountpoint=/ -o canmount=noauto zroot/ROOT/default || return 1

    zfs create -o mountpoint=none zroot/data || return 1
    zfs create -o mountpoint=/home zroot/data/home || return 1
    zfs create -o mountpoint=/root zroot/data/home/root || return 1

    zfs create -o mountpoint=/var -o canmount=off     zroot/var || return 1
    zfs create                                        zroot/var/log || return 1
    zfs create -o mountpoint=/var/lib -o canmount=off zroot/var/lib || return 1
    zfs create                                        zroot/var/lib/containers || return 1
    zfs create                                        zroot/var/lib/docker || return 1
    zfs create                                        zroot/var/lib/libvirt || return 1

    # Important: Export the pool
    zpool export zroot || return 1

    # Format the BOOT partition to fat32
    if [[ ${BOOTMODE:?} = UEFI ]] ; then
        mkfs.fat -F32 -n EFI /dev/disk/by-partlabel/EFI || return 1
    else
        mkfs.fat -F32 -n BOOT /dev/disk/by-partlabel/BOOT || return 1
    fi
}
