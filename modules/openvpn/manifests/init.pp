class openvpn {

  package { 'openvpn':
    ensure => installed,
  }

  service { 'openvpn' :
    ensure => running,
    enable => true,
  }

  file { '/etc/openvpn/':
    ensure  => directory,
    require => Package['openvpn'],
  }

  File {
    notify => Service['openvpn'],
  }

  file { '/etc/openvpn/vpn-route-up.sh':
    ensure  => file,
    mode    => '0755',
    content => template('openvpn/vpn-route-up.sh.erb'),
  }

  file { '/etc/openvpn/vpn-up.sh':
    ensure  => file,
    mode    => '0755',
    content => template('openvpn/vpn-up.sh.erb'),
  }

  augeas { '/etc/openvpn/ovpn-inet.conf':
    incl    => '/etc/openvpn/ovpn-inet.conf',
    lens    => 'OpenVPN.lns',
    changes => [
      'set dev-type tun',
      'set dev ovpn-inet',
      'set route-up vpn-route-up.sh',
      'set ping 10',
      'set ping-restart 60',
      'remove ping-exit',
      'touch route-noexec',
      'set up vpn-up.sh',
      'set script-security 2',
    ],
    notify  => Service['openvpn'],
  }

  file { '/etc/default/openvpn':
    ensure  => file,
    mode    => '0644',
    content => template('openvpn/etc-default-openvpn.erb'),
    notify  => Service['openvpn'],
  }
}

