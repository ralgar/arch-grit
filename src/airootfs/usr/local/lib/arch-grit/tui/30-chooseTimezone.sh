#########################################
###   TUI LIBRARY - CHOOSE TIMEZONE   ###
#########################################

chooseTimezone() {
    welcomeMessage    # Clear screen

  	printf "${bld}${yel}Select your timezone and subzone:${off}\n\n"
  	cd /usr/share/zoneinfo
  	PS3="Select ZONE: "
  	GLOBIGNORE="posix*:right:zone*:leap*:tzdata*:Etc:*[0-9]*"
    setterm -cursor on
  	select zone in * ; do
  		  if [[ -f $zone ]] ; then
  			    export TZ="$zone"
  			    break
  		  elif [[ -d $zone ]] ; then
  			    cd $zone
            printf "\n\n"
            PS3="Select SUBZONE: "
  			    select subzone in * "Go Back" ; do
  				      if [[ $subzone = "Go Back" ]] ; then
  					        chooseTimezone
  					        break
  				      else
  					        export TZ="$zone/$subzone"
  					        break
  				      fi
  			    done
  		  fi
  		  break
  	done
  	unset GLOBIGNORE
}

chooseTimezone
