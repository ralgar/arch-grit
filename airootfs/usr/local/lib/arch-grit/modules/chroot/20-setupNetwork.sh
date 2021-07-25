#!/bin/bash


trap "exit 1" 1 2 3 SIGTRAP 6 14 15

# Set system hostname and configure hosts file
echo "${HNAME:?}" >> /etc/hostname || exit 1
echo "127.0.0.1	localhost" >> /etc/hosts || exit 1
echo "::1		localhost" >> /etc/hosts || exit 1
echo "127.0.1.1	${HNAME:?}.localdomain	${HNAME:?}" >> /etc/hosts || exit 1

# Enable networking services
systemctl enable NetworkManager.service || exit 1


exit 0
