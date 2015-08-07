class collectd (
  $supernodenum
) {

  package { 'collectd':
    ensure => installed,
  }
  
  service { 'collectd':
    ensure => running,
    enable => true,
  }

  file { '/etc/collectd':
    ensure  => directory,
    require => Package['collectd'],
  }

  file { '/etc/collectd/collectd.conf':
    ensure  => file,
    mode    => '0644',
    content => template('collectd/collectd.conf.erb'),
    notify  => Service['collectd'],
  }
}
