class dhcpd (
  $gateway_router_host = 1,
  $ipv4_subnet_start,
  $ipv4_subnet_end,
) {
  $ipv4_regex = '(\d+\.){3}\d+'
  validate_re($ipv4_subnet_start, $ipv4_regex)
  validate_re($ipv4_subnet_end, $ipv4_regex)

  validate_integer($gateway_router_host)

  package { 'isc-dhcp-server':
    ensure  => installed,
  }

  systemd::service { 'isc-dhcp-server':
    ensure => present,
    source => 'puppet:///modules/dhcpd/isc-dhcp-server.service',
  } ~>

  service { 'isc-dhcp-server':
    ensure   => running,
    enable   => true,
    provider => 'systemd',
    require  => [
      Package['isc-dhcp-server'],
      Service['fastd'],
    ],
  }

  file { '/etc/dhcp/dhcpcd.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('dhcpd/dhcpd.conf.erb'),
    require => Package['isc-dhcp-server'],
    notify  => Service['isc-dhcp-server'],
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
