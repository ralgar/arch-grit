setterm -cursor on
PS3="Select the desired video driver: "
select VDRV in "AMD Open Source" "Intel Open Source" "NVIDIA Open Source" "NVIDIA Proprietary" "VMWare Video /w Virtual Box Guest Utils" "QXL Video" ; do
    case $VDRV in
        "AMD Open Source") break ;;
        "Intel Open Source") break ;;
        "NVIDIA Open Source") break ;;
        "NVIDIA Proprietary") break ;;
        "VMWare Video /w Virtual Box Guest Utils") break ;;
        "QXL Video") break ;;
        *) echo "Invalid choice [$REPLY]" ;;
    esac
done

export VDRV=$VDRV
