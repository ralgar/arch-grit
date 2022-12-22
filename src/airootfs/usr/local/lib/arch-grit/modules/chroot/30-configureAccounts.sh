#!/bin/bash


trap "exit 1" 1 2 3 SIGTRAP 6 14 15

# Change the default shell and set password for root account
usermod -s /usr/bin/zsh root || exit 1
echo root:"${RPASS:?}" | chpasswd || exit 1

# Create user directories in /etc/skel
for dir in '.config' 'bin' 'Documents' 'Music' 'Pictures' 'Projects' 'Videos' ; do
    mkdir "/etc/skel/$dir"
done

# Create the user account, set its password and sudo privileges
useradd -M -G wheel -s /usr/bin/zsh "${UNAME:?}" || exit 1
echo "${UNAME:?}":"${UPASS:?}" | chpasswd || exit 1
echo "${UNAME:?} ALL=(ALL) ALL" > /etc/sudoers.d/"${UNAME:?}" || exit 1
zfs create -o mountpoint="/home/${UNAME:?}" "zroot/data/home/${UNAME:?}" || exit 1
chmod 700 "/home/${UNAME:?}" || exit 1
shopt -s dotglob || exit 1
cp -r /etc/skel/* "/home/${UNAME:?}" || exit 1
chown -R "${UNAME:?}:${UNAME:?}" "/home/${UNAME:?}" || exit 1


exit 0
