#########################################
###   TUI LIBRARY - CHOOSE HOSTNAME   ###
#########################################

welcomeMessage    # Clear screen

read -r -p "Enter the hostname for the system (lowercase only): " HNAME
[[ -z $HNAME ]] && HNAME="arch-linux"
export HNAME=$HNAME
