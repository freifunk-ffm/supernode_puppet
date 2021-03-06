class batman ($ipv4_suffix, $ipv4_subnet_start){
  # FIXME can't we use the batman module supplied by the kernel?

  file {
    "/lib/modules/${::kernelrelease}/kernel/net/batmand-adv/batman_adv.ko":
      ensure => absent,
      before => Package['batman-adv-dkms'],
  }

  package { 'batman-adv-dkms':
    ensure  => installed,
    require => Class['apt::update'],
  }
  package { 'batctl':
    ensure  => installed,
    require => Class['apt::update'],
  }

  package { 'uml-utilities':
    ensure  => installed,
  }

  file { '/etc/modules-load.d/batman-adv.conf':
    ensure => file,
    content => 'batman-adv',
    owner => 'root',
    group => 'root',
    mode => '0644',
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
