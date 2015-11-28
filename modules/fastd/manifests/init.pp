class fastd (
  $supernodenum,
  $fastd_key,
  $ipv4_net,
  $ipv4_subnet_start,
  $ipv4_suffix,
  $ipv6_net,
  $ipv6_rnet,
  $ipv6_rnet_prefix,
  $ipv6_rnet_mask,
  $rndmac,
) {
  $user = 'fastd_serv'
  $legacy_service = 'fastd'

  package { [
    'fastd', 'bridge-utils', 'curl',
  ]:
    ensure  => installed,
  }

  Class['apt::update'] -> Package['fastd']

  include git

  user { $user:
    ensure     => present,
    shell      => '/bin/bash',
    home       => '/home/fastd_serv',
    managehome => true,
  }

  service { $legacy_service:
    ensure  => stopped,
    enable  => false,
  }

  file { '/etc/default/fastd':
    ensure => absent,
    before => Service['fastd'],
  }

  file { '/etc/fastd':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Package['fastd'],
  }

   file { '/etc/systemd/system/fastd@.service':
     ensure => file,
     owner  => 'root',
     group  => 'root',
     mode   => '0644',
     source => 'puppet:///modules/fastd/fastd@.service',
   }

  file { '/etc/cron.d/fastd':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    content => template('fastd/fastd-cron.erb'),
    mode    => '0755',
  }

  Vcsrepo {
    ensure   => present,
    require  => Class['git'],
    provider => 'git',
  }

  vcsrepo { '/etc/fastd/backbone':
    require => File['/etc/fastd'],
    source  => 'https://github.com/freifunk-ffm/fastd-backbone-config';
  }
}
