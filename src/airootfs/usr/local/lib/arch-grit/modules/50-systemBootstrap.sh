######################################
###   LIBRARY - SYSTEM BOOTSTRAP   ###
######################################
systemBootstrap() {

    # Assemble the list of packages
    pkglist=()
    for list in "${libPath}"/pkglists/*.repo ; do
        while IFS= read -r line; do
            pkglist+=("$line")
        done < "$list"
    done

    case ${BOOTMODE:?} in
        'UEFI')
            pkglist+=("grub" "efibootmgr") ;;
        'BIOS')
            pkglist+=("grub") ;;
    esac

    # Determine CPU microcode package
    case $(lscpu | grep ^Vendor | awk '{print $3}') in
        'GenuineIntel')
            pkglist+=('intel-ucode') ;;
        'AuthenticAMD')
            pkglist+=('amd-ucode') ;;
        *)
            printf "ERROR: Unable to determine CPU vendor!\n"
            return 1 ;;
    esac

    pacstrap /mnt "${pkglist[@]}" || return 1

    # Copy additional installation files
    cp -ar "${libPath}" "/mnt/${libPath#/}" || return 1
    chmod -R 755 "/mnt/${libPath#/}/modules/chroot"
    cp -ar /etc/pacman.conf /mnt/etc/ || return 1
    shopt -s dotglob || return 1
    rm -rf /mnt/etc/skel/* || return 1
    shopt -u dotglob || return 1
}
