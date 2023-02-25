#!/bin/bash

trap "exit 1" 1 2 3 SIGTRAP 6 14 15

# shellcheck disable=SC2154
cp -ar "${libPath}"/rootfs/* / || return 1
chmod 755 /usr/share/libalpm/scripts/zfs-snapshot || return 1

# Enable system services
systemctl enable cpupower.service || exit 1
systemctl enable paccache.timer || exit 1
systemctl enable smartd.service || exit 1

# Enable ZFS services and targets
systemctl enable zfs.target || exit 1
systemctl enable zfs-import.target || exit 1
systemctl enable zfs-import-cache.service || exit 1
systemctl enable zfs-mount.service || exit 1
systemctl enable zfs-trim@zroot.timer || exit 1
systemctl enable zfs-scrub-weekly@zroot.timer || exit 1

# Sysctl - Tweaks/optimizations
echo "kernel.sysrq = 1" > /etc/sysctl.d/80-sysrq.conf || exit 1
echo "vm.swappiness = 10" > /etc/sysctl.d/90-swappiness.conf || exit 1
echo "fs.inotify.max_user_watches = 600000" > /etc/sysctl.d/99-max_user_watches.conf || exit 1

# Set user in sshd - the daemon is not enabled by default
sed -i "s/my_user/${UNAME:?}/" /etc/ssh/sshd_config || exit 1

exit 0
