Do not use this unless you know exactly what you're doing!

This is just a dirty collection of puppet modules.

Setup
* set host name
* place firewall file in /etc/fw
* edit manifests/supernode.pp (fastdnum + key)
* puppet apply  --modulepath modules manifests/supernode.pp
* edit /etc/openvpn/ovpn-inet.conf and adapt to vpn-provier
* generate a hash (doveadm -pw ssha) using the the password found in /etc/postfis/sasl_passwd and add to /etc/dovecot/passwd on the mailserver
* test routing
