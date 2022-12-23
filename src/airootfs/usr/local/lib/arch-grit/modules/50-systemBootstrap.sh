######################################
###   LIBRARY - SYSTEM BOOTSTRAP   ###
######################################
systemBootstrap() {
    # Bootstrap packages using the defined pkglists
    for list in "${libPath}"/pkglists/base.repo ; do
        xargs -a "$list" pacstrap /mnt || return 1
    done

    # Copy additional installation files
    cp -ar "${libPath}" "/mnt/${libPath#/}" || return 1
    chmod -R 755 "/mnt/${libPath#/}/modules/chroot"
    cp -ar /etc/pacman.conf /mnt/etc/ || return 1
    rm -rf /mnt/etc/skel || return 1
    cp -ar "${libPath}"/rootfs/* /mnt/ || return 1
}
