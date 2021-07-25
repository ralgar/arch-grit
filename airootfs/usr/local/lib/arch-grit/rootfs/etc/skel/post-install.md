# Post-Install Configuration

A list of optional steps to complete the configuration of some system components.



## Firewalld

By default, the `firewalld` service is enabled and connections are using the `public` zone.

In order to move the current NetworkManager connection to a different zone:
`$ nmcli connection show`
`$ nmcli connection modify <connection-name> connection.zone <new-zone>`

MDNS services (printing, etc) are enabled by default on the `home` zone.



## SSHD

The `sshd` configuration in this installation is hardened by default.

To connect to this machine as a host:
- Add public keys to `~/.ssh/authorized_keys`
- Run `$ systemctl enable sshd` to enable the service
