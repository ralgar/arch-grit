#####################################
###   LIBRARY - PARTITION DRIVE   ###
#####################################
partitionDrive() {
    local device="${1}"

    # Create BOOT, and encrypted SYSTEM partitions
    if [[ $ROOTSIZE -ne 0 ]] ; then
        ROOTSIZE="+$ROOTSIZE"
        ROOTSIZE+="GiB"
    fi
    if [[ $BOOTMODE = UEFI ]] ; then
        sgdisk --clear \
            --new=1:0:+1GiB       --typecode=1:ef00 --change-name=1:EFI \
            --new=2:0:"$ROOTSIZE" --typecode=2:bf00 --change-name=2:cryptsystem \
	"${device}" || return 1
    elif [[ $BOOTMODE = BIOS ]] ; then
        sgdisk --clear \
            --new=1:0:+1MiB       --typecode=1:ef02 --change-name=1:GRUB \
            --new=2:0:+1GiB       --typecode=2:8300 --change-name=2:BOOT \
            --new=3:0:"$ROOTSIZE" --typecode=3:bf00 --change-name=3:cryptsystem \
            "${device}" || return 1
    fi
}
