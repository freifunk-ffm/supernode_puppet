class fastd-1280 ($supernodenum, $fastd_key, $ipv6_net, $ipv6_rnet, $ipv6_rnet_prefix, $ipv6_rnet_mask) {

service { 'fastd-1280':
    ensure      => running,
    enable      => true,
    hasrestart  => true,
    hasstatus   => true,
    require     => [File['check_fastd-cron-1280'],File['/etc/fastd/mesh-vpn-1280'],File['/etc/fastd'],Package['fastd'],Package['bridge-utils'],Package['curl'],Package['git'], Service['fastd'], User['fastd_serv']],
  }
  
  file { ['/etc/fastd/mesh-vpn-1280']:
    ensure  => directory,
    owner   => root,
    group   => root,
    notify  => [File['verify-1280'], File['fastd.conf-1280'], Exec['fastd_backbone-1280'], Exec['fastd_blacklist-1280'], File['Mesh-vpn/peers-1280']],
    require => Package['fastd'],
  }

  file { 'check_fastd-cron-1280':
    ensure => file,
    path => '/etc/cron.d/fastd',
    content => template('fastd/fastd-cron.erb'),
    mode => 0755,
  }

  file { 'mesh-vpn/peers-1280':
    path    => '/etc/fastd/mesh-vpn-1280/peers',
    ensure  => directory,
    owner   => fastd_serv,
    group   => fastd_serv,
    require => User['fastd_serv'],
  }

  file { 'fastd-up-1280':
    path    => '/etc/fastd/mesh-vpn-1280/fastd-up',
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('fastd/fastd-up.erb'),
    require => Package['fastd'],
    notify  => Service['fastd-1280'],
  }

  file { 'fastd-on-establish-1280':
    path    => '/etc/fastd/mesh-vpn-1280/on-establish',
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('fastd/on-establish.erb'),
    require => Package['fastd'],
    notify  => Service['fastd-1280'],
  }

  file { 'fastd-on-disestablish-1280':
    path    => '/etc/fastd/mesh-vpn-1280/on-disestablish',
    owner   => root,
    group   => root,
    mode    => '0755',
    content => template('fastd/on-disestablish.erb'),
    require => Package['fastd'],
    notify  => Service['fastd-1280'],
  }

  file { 'verify-1280':
    path => '/etc/fastd/mesh-vpn-1280/verify',
    owner => root,
    group => root,
    mode => '0755',
    content => template('fastd/verify.erb'),
    require => [
      File['fastd.conf'] ],
    notify => Service['fastd'],
  }
  file { 'fastd-1280.conf':
    path    => '/etc/fastd/mesh-vpn-1280/fastd.conf',
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('fastd/fastd.conf.erb'),
    require => [
      File['fastd-up-1280'],
      File['fastd-on-establish-1280'],
      File['fastd-on-disestablish-1280'],
      Package['fastd'],
      Package['curl'],
    ],
    notify  => Service['fastd'],
  }
 exec { 'fastd_blacklist-1280':
   command => '/usr/bin/git clone https://github.com/freifunk-ffm/fastd-bacbone-config/blacklist /etc/fastd/blacklist',
   creates => '/etc/fastd/blacklist',
   require => Package['git'],
 }
 
  exec { 'fastd_backbone-1280':
    command => '/usr/bin/git clone https://github.com/freifunk-ffm/fastd-backbone-config \
/etc/fastd/mesh-vpn-1280/backbone',
    creates => '/etc/fastd/mesh-vpn-1280/backbone', 
    require => Package['git'],
  }
}

