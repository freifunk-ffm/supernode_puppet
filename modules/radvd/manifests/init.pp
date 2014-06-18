class radvd {
  package { 'radvd':
    ensure  => installed,
  }

  service { 'radvd':
    ensure      => running,
    enable      => true,
    hasrestart  => true,
    hasstatus  => true,
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
