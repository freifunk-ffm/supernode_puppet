class fastd ($supernodenum, $fastd_key, $fastd_web_service_auth) {
  package { 'fastd':
    ensure  => installed,
    require => [Augeas['sources_universe'], Exec['apt-get update']],
  }

  package { 'curl':
    ensure  => installed,
  }
  
  service { 'fastd':
    ensure      => running,
    enable      => true,
    hasrestart  => true,
    hasstatus   => true,
    require     => Package['fastd'],
  }
  
  file { ['/etc/fastd', '/etc/fastd/mesh-vpn']:
    ensure  => directory,
    owner   => root,
    group   => root,
    notify  => [File['fastd.conf'], Exec['fastd_backbone'], File['mesh-vpn/peers']],
    require => Package['fastd'],
  }

  file { 'mesh-vpn/peers':
    path    => '/etc/fastd/mesh-vpn/peers',
    ensure  => directory,
    owner   => fastd_serv,
    group   => fastd_serv,
    require => User['fastd_serv'],
  }

  file { 'fastd.conf':
    path    => '/etc/fastd/mesh-vpn/fastd.conf',
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('fastd/fastd.conf.erb'),
    require => [
      Package['fastd'],
      Package['curl'],
    ],
    notify  => Service['fastd'],
  }

  file { 'fastd-up':
    path    => '/etc/fastd/mesh-vpn/fastd-up',
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('fastd/fastd-up.erb'),
    require => Package['fastd'],
    notify  => Service['fastd'],
  }

  exec { 'fastd_backbone':
    command => '/usr/bin/git clone https://github.com/ff-kbu/fastd-pubkeys \
/etc/fastd/mesh-vpn/backbone',
    creates => '/etc/fastd/mesh-vpn/backbone', 
    require => Package['git'],
  }
}

