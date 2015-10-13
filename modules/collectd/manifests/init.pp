class collectd (
  $supernodenum
) {

  package { ['collectd', 'iptables-dev']:
    ensure => installed,
  }
  
  service { 'collectd':
    ensure  => running,
    enable  => true,
    require => Package['iptables-dev'],
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