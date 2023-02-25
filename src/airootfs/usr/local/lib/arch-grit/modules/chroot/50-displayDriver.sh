#!/bin/bash


trap "exit 1" 1 2 3 SIGTRAP 6 14 15

# Install the selected display driver, and set the initramfs modules
case ${VDRV:?} in
	"AMD Open Source")
		pacman -S --noconfirm xf86-video-amdgpu lib32-mesa || exit 1
		sed -i "s/MODULES=()/MODULES=(amdgpu)/" /etc/mkinitcpio.conf || exit 1
		;;
	"Intel Open Source")
		pacman -S --noconfirm xf86-video-intel lib32-mesa || exit 1
		sed -i "s/MODULES=()/MODULES=(i915)/" /etc/mkinitcpio.conf || exit 1
		;;
	"NVIDIA Open Source")
		pacman -S --noconfirm xf86-video-nouveau lib32-mesa || exit 1
		sed -i "s/MODULES=()/MODULES=(nouveau)/" /etc/mkinitcpio.conf || exit 1
		;;
	"NVIDIA Proprietary")
		pacman -S --noconfirm nvidia-dkms lib32-nvidia-utils || exit 1
		sed -i "s/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/" /etc/mkinitcpio.conf || exit 1
		#if [[ $BOOTMODE = UEFI ]] ; then
		#	sed -i "s/quiet/nvidia-drm.modeset=1 quiet/" /boot/refind_linux.conf || exit 1
		#elif [[ $BOOTMODE = BIOS ]] ; then
		#	sed -i "s/quiet/nvidia-drm.modeset=1 quiet/" /etc/default/grub || exit 1
		#fi
		;;
	"VMWare Video /w Virtual Box Guest Utils")
		pacman -S --noconfirm virtualbox-guest-utils virtualbox-guest-dkms || exit 1
		systemctl enable vboxservice.service || exit 1
		sed -i "s/MODULES=()/MODULES=(vboxvideo)/" /etc/mkinitcpio.conf || exit 1
		;;
	"QXL Video")
		sed -i "s/MODULES=()/MODULES=(qxl)/" /etc/mkinitcpio.conf || exit 1
#		;;
esac


exit 0
