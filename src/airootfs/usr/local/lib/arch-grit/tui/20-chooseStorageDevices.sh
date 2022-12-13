###############################################
###   LIBRARY - CHOOSE INSTALLATION DRIVE   ###
###############################################

driveSelect() {
    fdisk -lo Size | grep "Disk /dev" | sed -e "s/Disk //" -e "s/B,.*/B/"
    driveList=$(fdisk -lo Size | grep "Disk /dev/" | sed -e "s/Disk //" -e "s/: .*//" | awk -v OFS=' ' '{ print $0 }')
    printf "${bld}${yel}WARNING: THIS WILL PERMANENTLY ERASE ALL DATA ON THE DRIVE!${off}\n"
    PS3='Enter your choice of disk to partition: '
    select DRIVE in $driveList ; do
        yes_cmd="eraseDrive=1"
        no_cmd="eraseDrive=0"
        yesorno "Do you want to securely erase $DRIVE before installation?"
        yes_cmd="sleep .5"
        no_cmd="driveSelect"
        setterm -cursor on
        if [[ $eraseDrive == 1 ]] ; then
            yesorno "Are you sure you want to ERASE and install on $DRIVE?"
        else
            yesorno "Are you sure you want to SKIP erasing, and install on $DRIVE?"
        fi

        # Choose partition size
        setterm -cursor on
        printf "\n${bld}${yel}Enter the size of the ROOT partition, or enter '0' to use all available space.${off}\n"
        read -p "Size (in GiB): " ROOTSIZE
        setterm -cursor off
        DRIVESIZE=$(fdisk -lo Size "$DRIVE" | grep "Disk /dev/" | awk '{ print $3 }')
        if [[ ! "$ROOTSIZE" =~ ^[0-9]+$ ]] ; then
            printf "The value entered must be an integer!"
            sleep 2 ; driveSelect
        elif [[ $ROOTSIZE > $DRIVESIZE ]] ; then
            printf "You cannot use a partition size greater than your total drive size!"
            sleep 2 ; driveSelect
        elif [[ $ROOTSIZE -lt 8 && $ROOTSIZE != 0 ]] ; then
            printf "You need a minimum root partition size of 8 GiB!"
            sleep 2 ; driveSelect
        fi

        # Export variables
        export DRIVE ; export ROOTSIZE

        # Check for block device type and TRIM support
        [[ $(cat /sys/block/"${DRIVE:5}"/queue/rotational) == 0 ]] &&
            export SSD=1
        [[ $(lsblk --discard | grep -w "${DRIVE:5}" | awk '{ print $3 }') != "0B" ]] &&
        [[ $(lsblk --discard | grep -w "${DRIVE:5}" | awk '{ print $4 }') != "0B" ]] &&
            export TRIM=1
        break
    done
}

welcomeMessage
driveSelect
