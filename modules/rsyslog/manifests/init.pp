class rsyslog {
  package { 'rsyslog':
    ensure  => installed,
  }

  include ::logrotate

  service { 'rsyslog':
    ensure  => running,
    enable  => true,
    require => Package['rsyslog'],
  }

  file { '/etc/rsyslog.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/rsyslog/rsyslog.conf',
    require => Package['rsyslog'],
    notify  => Service['rsyslog'],
  }

  file { '/etc/rsyslog.d/01-fastd.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/rsyslog/01-fastd.conf',
    require => Package['rsyslog'],
    notify  => Service['rsyslog'],
  }
}
