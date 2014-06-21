class dhcpd {
  package { 'isc-dhcp-server':
    ensure  => installed,
  }

  service { 'isc-dhcp-server':
    ensure      => running,
    enable      => true,
    hasrestart  => true,
    hasstatus   => true,
    require     => [Package['isc-dhcp-server'], Service['fastd'], Service['tinc']],
  }

  file { 'dhcpd.conf':
    ensure  => file,
    path    => '/etc/dhcp/dhcpd.conf',
    owner   => root,
    group   => root,
    mode    => 644,
    content => template('dhcpd/dhcpd.conf.erb'),
    require => Package['isc-dhcp-server'],
    notify  => Service['isc-dhcp-server'],
  }

  file { 'logrotate.d/dhcpd':
    ensure  => file,
    path    => '/etc/logrotate.d/dhcpd',
    owner   => root,
    group   => root,
    mode    => 644,
    source  => 'puppet:///modules/dhcpd/logrotate',
    require => [Package['logrotate'], File['rsyslog.conf']],
  }
}
