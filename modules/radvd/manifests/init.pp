class radvd ($ipv6_subnet, $ipv6_net, $ipv6_rnet) {
  package { 'radvd':
    ensure  => installed,
  }

  service { 'radvd':
    ensure => running,
    enable => true,
  }

  file { '/etc/radvd.conf':
    ensure  => file,
    content => template('radvd/radvd.conf.erb'),
    notify  => Service['radvd'],
    require => Package['radvd'],
  }
}
