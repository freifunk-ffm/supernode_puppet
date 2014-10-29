class collectd ( $supernodenum ) {

  package { 'collectd': ensure => installed, }
  
  service { 'collectd':
    ensure => running,
    enable => true,
    hasrestart => true,
    hassstatus => true,
    require => Package['collectd']
  }
  file { ['/etc/collectd']:
    ensure => directory,
    notify => [File['collectd_config'] ],
    require => Package['collectd']
  }

  file { 'collectd_config':
    ensure => file,
    mode => 0644,
    path => '/etc/collectd/collectd.conf',
    content => template('collectd/collectd.conf.erb'),
    notify => Service['collectd']
  }
}
