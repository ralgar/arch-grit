##################################
###   LIBRARY - SECURE ERASE   ###
##################################
secureErase() {
    device="${1}"

    # Open a randomly encrypted container on the entire drive
    cryptsetup open -q --type plain "${device}" container --key-file /dev/urandom || return 1

    # Zero the encrypted container to securely erase the drive
    # This command WILL fail by design, so "or return 1" is not set here
    dd if=/dev/zero of=/dev/mapper/container status=progress bs=1M

    # Close the encrypted container
    cryptsetup close container || return 1
}
