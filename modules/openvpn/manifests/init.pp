class openvpn {

package { 'openvpn': ensure => installed; }

  service { openvpn :
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus => false,
    require => Package['openvpn']
  }

  file { ['/etc/openvpn/']:
    ensure => directory,
    notify => [File['openvpn-default'], File['openvpn_vpn-up'], File['openvpn_vpn-route'],Exec['openvpn_config_1'], Exec['openvpn_config_2'], Exec['openvpn_config_3'], Exec['openvpn_config_4'],  Exec['openvpn_config_5'], Exec['openvpn_config_6'],Exec['openvpn_config_7'],Exec['openvpn_config_8'],Exec['openvpn_config_9'] ],
    require => Package['openvpn'],
  }

  file { 'openvpn_vpn-route':
    ensure  => file,
    mode    => 0755,
    path    => '/etc/openvpn/vpn-route-up.sh',
    content => template('openvpn/vpn-route-up.sh.erb'),
    notify  => Service['openvpn'],
  }

  file { 'openvpn_vpn-up':
    ensure  => file,
    mode    => 0755,
    path    => '/etc/openvpn/vpn-up.sh',
    content => template('openvpn/vpn-up.sh.erb'),
    notify  => Service['openvpn'],
  }

  exec { 'openvpn_config_6':
    command => '/bin/echo "dev-type tun" >> /etc/openvpn/ovpn-inet.conf',
    unless  => '/bin/grep "dev-type tun" /etc/openvpn/ovpn-inet.conf',
  }
  exec { 'openvpn_config_5':
    command => '/bin/echo "dev ovpn-inet" >> /etc/openvpn/ovpn-inet.conf',
    unless  => '/bin/grep "dev ovpn-inet" /etc/openvpn/ovpn-inet.conf',
  }
  exec { 'openvpn_config_1':
    command => '/bin/echo "route-up vpn-route-up.sh" >> /etc/openvpn/ovpn-inet.conf',
    unless  => '/bin/grep "route-up vpn-route-up.sh" /etc/openvpn/ovpn-inet.conf',
  }
  exec { 'openvpn_config_9':
    command => '/bin/echo "ping 10" >> /etc/openvpn/ovpn-inet.conf',
    unless  => '/bin/grep "ping " /etc/openvpn/ovpn-inet.conf',
  }
  exec { 'openvpn_config_7':
    command => '/bin/echo "ping-restart 60" >> /etc/openvpn/ovpn-inet.conf',
    unless  => '/bin/grep "ping-restart" /etc/openvpn/ovpn-inet.conf',
  }
  exec { 'openvpn_config_8':
    command => '/bin/sed "d/ping-exit.*/" -i /etc/openvpn/ovpn-inet.conf',
    unless  => '/bin/grep -q -v ping-exit /etc/openvpn/ovpn-inet.conf',
  }

  exec { 'openvpn_config_2':
    command => '/bin/echo "route-noexec" >> /etc/openvpn/ovpn-inet.conf',
    unless  => '/bin/grep "route-noexec" /etc/openvpn/ovpn-inet.conf',
  }

  exec { 'openvpn_config_3':
    command => '/bin/echo "up vpn-up.sh" >> /etc/openvpn/ovpn-inet.conf',
    unless  => '/bin/grep "up vpn-up.sh" /etc/openvpn/ovpn-inet.conf',
  }
  exec { 'openvpn_config_4':
    command => '/bin/echo "script-security 2" >> /etc/openvpn/ovpn-inet.conf',
    unless  => '/bin/grep "script-security 2" /etc/openvpn/ovpn-inet.conf',
  }

   file { 'openvpn-default':
        ensure => file,
	mode => 0644,
	content => template('openvpn/etc-default-openvpn.erb'),
	path  => '/etc/default/openvpn',
	notify => Service['openvpn']
    }
			      
}

