#!/bin/bash
#####################################################################
###  	THIS FILE CALLS THE MODULES FOR THE ULTIMATE INSTALLATION   ###
#####################################################################

welcomeMessage
printf "${bld}${red}### ${pur}Beginning Installation ${red}###${off}\n\n"

##############################
###   Prepare the system   ###
##############################

# Source the libraries
. "${libPath}/modules/00-secureErase.sh"
. "${libPath}/modules/10-partitionDrive.sh"
. "${libPath}/modules/20-formatPartitions.sh"
. "${libPath}/modules/30-mountFilesystems.sh"
. "${libPath}/modules/40-optimizeMirrors.sh"
. "${libPath}/modules/50-systemBootstrap.sh"
. "${libPath}/modules/60-generateFstab.sh"
. "${libPath}/modules/99-unmountFilesystems.sh"

# Securely erase the drive
desc="Securely erasing ${DRIVE}"
if [[ $eraseDrive == 1 ]] ; then
    run secureErase "${DRIVE:?}"
else
    printf "[ ${bld}${yel}WARN${off} ]  Skipping secure drive erase...\n"
fi

# Partition the drive
desc="Partitioning ${DRIVE}"
run partitionDrive "${DRIVE:?}"

# Format and encrypt the partitions
desc="Formatting and encrypting partitions"
run formatPartitions

# Mount the filesystems
desc="Mounting filesystems"
run mountFilesystems


####################################
###   BOOTSTRAP THE NEW SYSTEM   ###
####################################

# Optimize the mirror list for speed
# This module is not critical and has been known to fail, so it does not call run(),
#   it still has smart output scripted in the module itself
optimizeMirrors

# Install native package list from pkglist.txt, and copy installation scripts to new system
desc="Bootstrapping the new system"
run systemBootstrap

# Generate the fstab
desc="Generating fstab"
run generateFstab


########################################
###	Chroot and finalize
########################################

# Set the system clocks
desc="Setting the system time"
run arch-chroot /mnt "${libPath}/modules/chroot/00-setClock.sh"

# Generate the localization
desc="Generating localization"
run arch-chroot /mnt "${libPath}/modules/chroot/10-generateLocale.sh"

# Configure hostname, hosts file, and enable networking service
desc="Enabling networking"
run arch-chroot /mnt "${libPath}/modules/chroot/20-setupNetwork.sh"

# Set up the root and user accounts
desc="Configuring accounts"
run arch-chroot /mnt "${libPath}/modules/chroot/30-configureAccounts.sh"

# Install PARU, and AUR (foreign) package list from pkglistAUR.txt
desc="Installing AUR packages"
run arch-chroot /mnt "${libPath}/modules/chroot/40-aurPackages.sh"

# Install the selected display driver
desc="Installing display driver"
run arch-chroot /mnt "${libPath}/modules/chroot/50-displayDriver.sh"

# Final configurations (enable services, set config files, etc.)
desc="Finalizing configuration"
run arch-chroot /mnt "${libPath}/modules/chroot/60-systemConfig.sh"

# Configure and generate the initramfs
desc="Generating initramfs"
run arch-chroot /mnt "${libPath}/modules/chroot/70-generateInitrd.sh"

# Configure and install the bootloader and CPU microcode
desc="Installing bootloader and CPU microcode"
run arch-chroot /mnt "${libPath}/modules/chroot/80-installBootloader.sh"

###########################################
###   Unmount filesystems and cleanup   ###
###########################################
desc="Unmounting filesystems"
run unmountFilesystems
