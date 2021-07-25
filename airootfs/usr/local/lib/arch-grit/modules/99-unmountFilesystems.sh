#########################################
###   LIBRARY - UNMOUNT FILESYSTEMS   ###
#########################################
unmountFilesystems() {
    # Remove installation files from new system
    rm -rf "/mnt/${libPath}" || return 1

    # Unmount all filesystems to complete the installation
    timeout=0
    until umount -R /mnt ; do
        sleep 5
        timeout=$(($timeout+5))
        [[ $timeout = 60 ]] && exit 1
    done
}
