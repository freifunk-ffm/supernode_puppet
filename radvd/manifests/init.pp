class radvd ($ipv6_subnet) {
  package { 'radvd':
    ensure  => installed,
  }

  service { 'radvd':
    ensure      => running,
# enable => true & hasstatus => true geändert durch ipv6 fuckup in ffm
    enable      => false,
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
