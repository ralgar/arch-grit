#################################################
###   TUI LIBRARY - PRE-INSTALLATION CHECKS   ###
#################################################

preInstallation() {
    # Check for an internet connection
    if ! ping -c 1 archlinux.org &> /dev/null ; then
        printf "${bld}${yel}No internet connection found! Connect to the internet, and then run the installer again.${off}"
        exit 2
    fi

    # Set the system clock
    if ! timedatectl set-ntp true &> /dev/null ; then
        printf "[  ${bld}${red}FAIL${off}  ]  Failed to set the system clock. This is required for proper synchronization with the package mirrors."
        exit 2
    fi

    # Check boot mode (UEFI or BIOS)
    if [[ -d /sys/firmware/efi/efivars ]] ; then
        export BOOTMODE=UEFI
    else
        export BOOTMODE=BIOS
    fi
}

welcomeMessage() {
    # WELCOME MESSAGE
    clear
    printf "\n${bld}${red}###  ${pur}Welcome to the Arch Graphical Recovery and Installation Tool ( ${cyn}Arch-GRIT${pur} )!  ${red}###${off}\n\n\n"
    sleep 1
}

welcomeMessage
preInstallation
