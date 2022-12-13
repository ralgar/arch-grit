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
useradd -m -G wheel -s /usr/bin/zsh "${UNAME:?}" || exit 1
echo "${UNAME:?}":"${UPASS:?}" | chpasswd || exit 1
echo "${UNAME:?} ALL=(ALL) ALL" > /etc/sudoers.d/"${UNAME:?}" || exit 1

# For ultimate installation, create btrfs subvolumes in user's home directory
sudo -u "${UNAME:?}" btrfs subvolume create /home/"${UNAME:?}"/.cache || exit 1
sudo -u "${UNAME:?}" btrfs subvolume create /home/"${UNAME:?}"/.local || exit 1
sudo -u "${UNAME:?}" btrfs subvolume create /home/"${UNAME:?}"/Downloads || exit 1

# Install dotfiles
sudo -u "${UNAME:?}" \
    git clone https://github.com/basschaser/dotfiles.git \
    "/home/${UNAME:?}/dotfiles" || exit 1
sudo -u "${UNAME:?}" "/home/${UNAME:?}/dotfiles/install.sh" || exit 1
rm -rf "/home/${UNAME:?}/dotfiles" || exit 1


exit 0
