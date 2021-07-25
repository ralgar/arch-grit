#!/bin/bash


trap "exit 1" 1 2 3 SIGTRAP 6 14 15

# Configure the system locale
echo "LANG=en_US.UTF-8" > /etc/locale.conf || exit 1
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen || exit 1
locale-gen || exit 1


exit 0
