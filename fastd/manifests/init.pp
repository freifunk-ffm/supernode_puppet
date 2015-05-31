class fastd ($supernodenum, $fastd_key, $ipv6_net, $ipv6_rnet, $ipv6_rnet_prefix, $ipv6_rnet_mask) {


  package { 'fastd':
    ensure  => installed,
    require => [Augeas['sources_universe'], Exec['apt-get update']],
  }
  package { 'git':
	ensure => installed,
  }

  user { 'fastd_serv':
    ensure      => present,
    shell       => '/bin/bash',
    home        => '/home/fastd_serv',
    managehome  => true,
  }


  package { 'bridge-utils':
	ensure => installed,
  }

  package { 'curl':
    ensure  => installed,
  }
  
  service { 'fastd':
    ensure      => running,
    enable      => true,
    hasrestart  => true,
    hasstatus   => true,
    require     => [ Package['fastd'], Package['bridge-utils'] ],
  }
  
  file { ['/etc/fastd', '/etc/fastd/mesh-vpn']:
    ensure  => directory,
    owner   => root,
    group   => root,
    notify  => [File['verify'], File['fastd.conf'], Exec['fastd_backbone'], Exec['fastd_blacklist'], File['mesh-vpn/peers']],
    require => Package['fastd'],
  }

  file { 'check_fastd-cron':
    ensure => file,
    path => '/etc/cron.d/fastd',
    content => template('fastd/fastd-cron.erb'),
    mode => 0755,
  }			          

  file { 'mesh-vpn/peers':
    path    => '/etc/fastd/mesh-vpn/peers',
    ensure  => directory,
    owner   => fastd_serv,
    group   => fastd_serv,
    require => User['fastd_serv'],
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

  file { 'fastd-on-establish':
    path    => '/etc/fastd/mesh-vpn/on-establish',
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('fastd/on-establish.erb'),
    require => Package['fastd'],
    notify  => Service['fastd'],
  }

  file { 'fastd-on-disestablish':
    path    => '/etc/fastd/mesh-vpn/on-disestablish',
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('fastd/on-disestablish.erb'),
    require => Package['fastd'],
    notify  => Service['fastd'],
  }


  file { 'verify':
    path => '/etc/fastd/mesh-vpn/verify',
    owner => root,
    group => root,
    mode => '0755',
    content => template('fastd/verify.erb'),
    require => [
      File['fastd.conf'] ],
    notify => Service['fastd'],
  }
  file { 'fastd.conf':
    path    => '/etc/fastd/mesh-vpn/fastd.conf',
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('fastd/fastd.conf.erb'),
    require => [
      File['fastd-up'],
      File['fastd-on-establish'],
      File['fastd-on-disestablish'],
      Package['fastd'],
      Package['curl'],
    ],
    notify  => Service['fastd'],
  }
 exec { 'fastd_blacklist':
   command => '/usr/bin/git clone https://github.com/freifunk-ffm/fastd-backbone-config /etc/fastd/blacklist',
   creates => '/etc/fastd/blacklist',
   require => Package['git'],
 }
 
  exec { 'fastd_backbone':
    command => '/usr/bin/git clone https://github.com/freifunk-ffm/fastd-backbone-config \
/etc/fastd/mesh-vpn/backbone',
    creates => '/etc/fastd/mesh-vpn/backbone', 
    require => Package['git'],
  }
}

