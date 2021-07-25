############################
### GENERATE THE FSTAB   ###
############################
generateFstab() {
    # Generate the fstab
    genfstab -L -p /mnt >> /mnt/etc/fstab || return 1

    # Add fstab entries for swap subvolume and file
    cat << EOF >> /mnt/etc/fstab || return 1

# Swap subvolume (@swap, no compression)
LABEL=system    /.swap    btrfs    rw,noatime,subvol=@swap    0 0

# Swap file
/.swap/file     none      swap     defaults,noatime           0 0
EOF
}
