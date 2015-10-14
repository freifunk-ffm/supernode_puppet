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

  $ovpn = '/etc/openvpn/ovpn-inet.conf'

  file { $ovpn:
    ensure => file,
    mode   => '0640',
  }

  File_line {
    path    => $ovpn,
  }

  # FIXME this should be implemented using augeas, but alas OpenVPN.lns is very
  # strict in the values it allows and is missing some settings we need and
  # disallows some values we want.

  file_line {
    "${ovpn}/dev-type":
      match => '^dev-type\s',
      line  => 'dev-type tun';
    "${ovpn}/dev":
      match => '^dev\s',
      line  => 'dev ovpn-inet';
    "${ovpn}/route-up":
      match => '^route-up\s',
      line  => 'route-up vpn-route-up.sh';
    "${ovpn}/ping":
      match => '^ping\s',
      line  => 'ping 10';
    "${ovpn}/ping-restart":
      match => '^ping-restart\s',
      line  => 'ping-restart 60';
    "${ovpn}/ping-exit":
      ensure => absent,
      match  => '^ping-exit',
      line   => '';
    "${ovpn}/route-noexec":
      match => '^route-noexec\s*',
      line  => 'reoute-noexec';
    "${ovpn}/up":
      match => '^up\s',
      line  => 'up vpn-up.sh';
    "${ovpn}/script-security":
      match => '^script-security\s',
      line  => 'script-security 2';
  }

  file { '/etc/default/openvpn':
    ensure  => absent,
  }
}

