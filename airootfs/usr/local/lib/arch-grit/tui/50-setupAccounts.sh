########################################
###   TUI LIBRARY - SETUP ACCOUNTS   ###
########################################

rootpwd () {
	  welcomeMessage    # Clear screen
	  read -r -s -p "Enter the new password for the root account: " RPASS
    printf "\n\n"
	  read -r -s -p "Confirm the password for the root account: " RPASS2
	  if [[ $RPASS = "$RPASS2" && -n $RPASS ]] ; then
		    export RPASS
	  else
		    printf "\n[  ${bld}${red}ERROR${off}  ] The passwords are empty or do not match.  Starting over.\n"
		    sleep 2 ; rootpwd
	  fi
}

usracct () {
  	welcomeMessage    # Clear screen
  	read -r -p "Enter a name for the user account (lowercase only): " UNAME
  	if [[ -z $UNAME ]] ; then
  		  printf "\n[  ${bld}${red}ERROR${off}  ] You must enter a username.\n"
  			sleep 2 ; usracct
  	fi

  	welcomeMessage    # Clear screen
  	read -r -s -p "Enter a password for the user account: " UPASS
    printf "\n\n"
  	read -r -s -p "Confirm the password for the user account: " UPASS2

  	if [[ $UPASS = "$UPASS2" && -n $UPASS ]] ; then
  		  export UNAME
  		  export UPASS
  	else
  		  printf "\n[  ${bld}${red}ERROR${off}  ] The passwords are empty or do not match.  Starting over.\n"
  		  sleep 2 ; usracct
  	fi
}

cryptpwd () {
  	welcomeMessage    # Clear screen
  	printf "${bld}${yel}WARNING: This passphrase is critically important.  DO NOT LOSE IT.${off}\n"
  	printf "${bld}${yel}         Without it, you will be unable to access ANY data on the drive.${off}\n\n"

  	read -r -s -p "Enter the passphrase for full drive encryption: " CPASS
    printf "\n\n"
  	read -r -s -p "Confirm the passphrase for full drive encryption: " CPASS2

		if [[ $CPASS = "$CPASS2" && -n $CPASS ]] ; then
  		  export CRYPTPASS="$CPASS"
  	else
  		  printf "\n[  ${bld}${red}ERROR${off}  ] The passwords are empty or do not match.  Starting over.\n"
  		  sleep 2 ; cryptpwd
  	fi
}

rootpwd
usracct
cryptpwd
setterm -cursor off
