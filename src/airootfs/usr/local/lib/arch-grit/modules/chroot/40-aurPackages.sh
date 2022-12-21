#!/bin/bash


trap "exit 1" 1 2 3 SIGTRAP 6 14 15

# Change user's sudo settings to no password (necessary for the duration of this script)
echo "${UNAME:?} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/"${UNAME:?}" || exit 1

# Set makepkg to use all cores for building and package compression
sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j$(nproc)\"/" /etc/makepkg.conf || exit 1
sed -i "s/(xz -c -z -)/(xz -c -z - --threads=0)/" /etc/makepkg.conf || exit 1

# Build and install PARU (AUR helper)
cd /home/"${UNAME:?}" || exit 1
sudo -u "${UNAME:?}" git clone https://aur.archlinux.org/paru-bin.git || exit 1
cd paru-bin || exit 1
sudo -u "${UNAME:?}" makepkg -si --noconfirm || exit 1
cd .. || exit 1
rm -rf paru-bin || exit 1

# for list in "${libPath:?}"/pkglists/*.aur ; do
#     # Install AUR packages from pkglistAUR.txt
#     sudo -u "${UNAME:?}" xargs -a "$list" paru -S --needed --noconfirm || exit 1
# done

# Return user's sudo settings to normal
echo "${UNAME:?} ALL=(ALL) ALL" > /etc/sudoers.d/"${UNAME:?}" || exit 1


exit 0
