class nrpe {
  package { 'nagios-nrpe-server':
    ensure => installed,
  }

  service { 'nagios-nrpe-server':
    ensure  => running,
    enable  => true,
    require => Package['nagios-nrpe-server'],
  }

  file { 'nrpe_local.cfg':
    ensure  => file,
    path    => '/etc/nagios/nrpe_local.cfg',
    owner   => root,
    group   => root,
    mode    => 644,
    source  => 'puppet:///modules/nrpe/nrpe_local.cfg',
    require => Package['nagios-nrpe-server'],
    notify  => Service['nagios-nrpe-server'],
  }

  file { 'nrpe.cfg':
    ensure  => file,
    path    => '/etc/nagios/nrpe.cfg',
    owner   => root,
    group   => root,
    mode    => 644,
    content => template('nrpe/nrpe.cfg.erb'),
    require => Package['nagios-nrpe-server'],
  }  
}
