class batman ($ipv4_suffix, $ipv4_subnet_start, $ipv6_subnet){

  package { 'batman-adv-dkms':
    ensure  => installed,
    require => [Augeas['sources_universe'], Exec['apt-get update']],
    notify  => Augeas['mod-batman'],
  }

  augeas { 'mod-batman':
    context => '/files/etc/modules',
    changes => 'ins batman-adv after *[last()]',
    onlyif  => 'match batman-adv size==0',
    notify  => Exec['modprobe batman'],
    require => Package['batman-adv-dkms'],
  }

  package { 'uml-utilities':
    ensure  => installed,
  }

  exec { 'modprobe batman':
    command => '/sbin/modprobe batman-adv',
    unless  => '/bin/grep -q batman_adv /proc/modules',
    require => Package['batman-adv-dkms'],
  }

  augeas { 'iface bat0 inet':
    context => '/files/etc/network/interfaces',
    changes => [
      'set auto[child::1 = "bat0"]/1 bat0',
      'set iface[. = "bat0"] bat0',
      'set iface[. = "bat0"]/family inet',
      'set iface[. = "bat0"]/method manual',
#      "set iface[. = \"bat0\"]/address 10.126.${ipv4_subnet_start}.${ipv4_suffix}",
#      'set iface[. = "bat0"]/netmask 255.255.0.0',
      'set iface[. = "bat0"]/pre-up "modprobe batman-adv && tunctl -t mesh-vpn && batctl if add mesh-vpn"',
    ],
    require => Package['uml-utilities'],
#    notify  => Augeas['iface bat0 inet6']
  }

#  augeas { 'iface bat0 inet6':
#   context => '/files/etc/network/interfaces',
#    changes => [
#      'set iface[. = "bat0.6"] bat0.6',
#      'set iface[. = "bat0.6"]/family inet6',
#      'set iface[. = "bat0.6"]/method static',
#      "set iface[. = \"bat0.6\"]/address 2001:67c:20a0:${ipv6_subnet}::1",
#      'set iface[. = "bat0.6"]/netmask 64',
#      'set iface[. = "bat0.6"] bat0',
#    ],
#    onlyif  => 'match iface[. = "bat0"][family = "inet6"] size == 0',
#  } 
}
