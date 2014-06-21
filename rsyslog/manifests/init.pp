class rsyslog {
  package { 'rsyslog':
    ensure  => installed,
  }

  package { 'logrotate':
    ensure  => installed,
  }

  service { 'rsyslog':
    ensure  => running,
    enable  => true,
    require => Package['rsyslog'],
  }
  
  file { 'rsyslog.conf':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 644,
    path    => '/etc/rsyslog.conf',
    source  => 'puppet:///modules/rsyslog/rsyslog.conf',
    require => Package['rsyslog'],
    notify  => Service['rsyslog'],
  }
}
