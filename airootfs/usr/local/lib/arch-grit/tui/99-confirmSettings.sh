###########################################
###   TUI LIBRARY - CONFIRM SETTINGS   ###
###########################################
welcomeMessage    # Clear screen

printf "${bld}${yel}We are now ready to begin the installation process.  Depending on the speed of your computer and internet connection, this may take a while.${off}\n"
sleep 1 ; printf "${bld}${yel}The installation is fully automated from this point on.${off}\n\n" ; sleep 1

printf "${bld}${yel}Please review the installation options before continuing:${off}\n\n"
printf "Boot Mode:			$BOOTMODE\n"
printf "Storage Device:			$DRIVE\n"
if [[ $SSD -eq 1 && $TRIM -eq 1 ]] ; then
    printf "Storage Type:			Solid-State /w TRIM Support\n"
elif [[ $SSD -eq 1 && -z $TRIM ]] ; then
    printf "Storage Type:			Solid-State w/o TRIM Support\n"
else
    printf "Storage Type:			Conventional Hard Drive\n"
fi
if [[ $ROOTSIZE -eq 0 ]] ; then
    printf "Root Partition Size:		All available space\n"
else
    printf "Root Partition Size:		$ROOTSIZE GB\n"
fi
printf "Display Driver:			$VDRV\n"
printf "Time Zone:			$TZ\n"
printf "Hostname:			$HNAME\n"
printf "Username:			$UNAME\n\n"

yes_cmd="sleep 1"
no_cmd="exit"
yesorno "Are you ready to begin the installation?"
