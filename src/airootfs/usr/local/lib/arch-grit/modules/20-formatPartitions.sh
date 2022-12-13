#######################################
###   LIBRARY - FORMAT PARTITIONS   ###
#######################################
formatPartitions() {
    # Wait until udev updates the partlabels (required)
    until [[ -e /dev/disk/by-partlabel/cryptsystem ]] ; do
        sleep 1
    done
    sleep 5

    # Create and open the encrypted LUKS container
    echo -n "${CRYPTPASS:?}" | cryptsetup luksFormat -d - --align-payload=8192 -s 256 \
        -c aes-xts-plain64 /dev/disk/by-partlabel/cryptsystem || return 1
    echo -n "${CRYPTPASS:?}" | cryptsetup open -d - \
        /dev/disk/by-partlabel/cryptsystem system || return 1

    # Format the decrypted LUKS container with btrfs
    mkfs.btrfs --force --label system /dev/mapper/system || return 1

    # Format the BOOT partition to fat32
    if [[ ${BOOTMODE:?} = UEFI ]] ; then
        mkfs.fat -F32 -n EFI /dev/disk/by-partlabel/EFI || return 1
    else
        mkfs.fat -F32 -n BOOT /dev/disk/by-partlabel/BOOT || return 1
    fi
}
