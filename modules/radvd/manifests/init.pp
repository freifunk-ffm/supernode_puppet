class radvd ($ipv6_subnet, $ipv6_net, $ipv6_rnet) {
  package { 'radvd':
    ensure  => installed,
  }

  service { 'radvd':
    ensure      => running,
    enable      => true,
    hasrestart  => true,
    hasstatus  => false,
    require     => Package['radvd'],
  }
  
  file { 'radvd.conf':
    ensure  => file,
    path    => '/etc/radvd.conf',
    content => template('radvd/radvd.conf.erb'),
    require => Package['radvd'],
    notify  => Service['radvd'],
  }
}
