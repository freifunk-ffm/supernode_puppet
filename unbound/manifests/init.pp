class unbound {
  package { 'unbound':
    ensure  => installed,
  }

  file { '/etc/unbound':
    ensure  => directory,
    owner   => root,
    group   => root,
    notify  => File['unbound.conf'],
    require => Package['unbound'],
  }

  file { 'unbound.conf':
    path    => '/etc/unbound/unbound.conf',
    owner   => root,
    group   => root,
    source  => 'puppet:///modules/unbound/unbound.conf',
  }

  service { 'unbound':
    ensure    => running,
    enable    => true,
    hasstatus => true,
    require   => [
      Package['unbound'], 
      File['unbound.conf'], 
      Augeas['iface lo post-up'],
      Augeas['iface bat0:0 inet'],
    ],
  }

  augeas { 'iface lo post-up':
    context => '/files/etc/network/interfaces',
    changes => [
      'set iface[. = "lo"]/post-up "ip -6 addr add fdd3:5d16:b5dd::2/128 dev lo"',
    ]
  }

  augeas { 'iface bat0:0 inet':
    context => '/files/etc/network/interfaces',
    changes => [
      'set auto[child::1 = "bat0:0"]/1 bat0:0',
      'set iface[. = "bat0:0"] bat0:0',
      'set iface[. = "bat0:0"]/family inet',
      'set iface[. = "bat0:0"]/method static',
      'set iface[. = "bat0:0"]/address 172.27.0.2',
      'set iface[. = "bat0:0"]/netmask 255.255.192.0',
    ],
  } 
}
