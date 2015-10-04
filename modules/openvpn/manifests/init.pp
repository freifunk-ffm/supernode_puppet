class openvpn {

  package { 'openvpn':
    ensure => installed,
  }

  service { 'openvpn':
    ensure => stopped,
    enable => false,
  } ->

  service { 'openvpn@ovpn-inet' :
    ensure   => running,
    enable   => true,
    provider => 'systemd',
  }

  file { '/etc/openvpn/':
    ensure  => directory,
    require => Package['openvpn'],
  }

  File {
    notify => Service['openvpn@ovpn-inet'],
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

  file { '/etc/openvpn/ovpn-inet.conf':
    ensure => file,
    source => 'puppet:///modules/openvpn/ovpn-inet.conf',
    mode   => '0640',
  }

  file { '/etc/default/openvpn':
    ensure  => absent,
  }
}

