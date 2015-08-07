class dhcpd (
  $supernodenum,
  $ipv4_subnet_start,
  $ipv4_subnet_end,
) {
  package { 'isc-dhcp-server':
    ensure  => installed,
  }

  service { 'isc-dhcp-server':
    ensure  => running,
    enable  => true,
    require => [
      Package['isc-dhcp-server'],
      Service['fastd'],
    ],
  }

  file { '/etc/dhcp/dhcpd.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dhcpd/dhcpd.conf.erb'),
    require => Package['isc-dhcp-server'],
    notify  => Service['isc-dhcp-server'],
  }

  logrotate::config { 'dhcpd':
    source  => 'puppet:///modules/dhcpd/logrotate',
    require => Package['isc-dhcp-server'],
  }
}
