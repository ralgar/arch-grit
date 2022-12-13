#!/bin/bash


trap "exit 1" 1 2 3 SIGTRAP 6 14 15

# Set system hostname and configure hosts file
echo "${HNAME:?}" >> /etc/hostname || exit 1
echo "127.0.0.1	localhost" >> /etc/hosts || exit 1
echo "::1		localhost" >> /etc/hosts || exit 1
echo "127.0.1.1	${HNAME:?}.localdomain	${HNAME:?}" >> /etc/hosts || exit 1

# Mask udev rule to get simple network interface names (eth0, wlan0)
ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules || exit 1

# Configure base networking services
systemctl enable firewalld.service || exit 1
systemctl enable NetworkManager.service || exit 1

# Enable network management for 'network' group
cat << EOF > /etc/polkit-1/rules.d/50-org.freedesktop.NetworkManager.rules || exit 1
polkit.addRule(function(action, subject) {
  if (action.id.indexOf("org.freedesktop.NetworkManager.") == 0 && subject.isInGroup("network")) {
    return polkit.Result.YES;
  }
});
EOF

# Enable printing services
systemctl enable  avahi-daemon.service || exit 1
systemctl enable  cups.socket || exit 1
systemctl disable systemd-resolved.service || exit 1
sed -i "s/resolve/mdns_minimal [NOTFOUND=return] resolve/" /etc/nsswitch.conf


exit 0
