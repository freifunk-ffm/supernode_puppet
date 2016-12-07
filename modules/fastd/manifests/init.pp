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

  package { [
    'fastd', 'bridge-utils', 'curl', 'nmap',
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

  systemd::service {
    'fastd-setup':
      content => template('fastd/fastd-setup.service');
    'fastd@':
      source => 'puppet:///modules/fastd/fastd@.service';
    'fastd':
      source => 'puppet:///modules/fastd/fastd.service';
  }

  systemd::network { 'batbridge':
    content => template('fastd/batbridge.network'),
  }

  systemd::netdev { 'batbridge':
    content => template('fastd/batbridge.netdev'),
  }

  service { ['fastd', 'fastd-setup']:
    ensure => running,
    enable => true,
  }

  $update_fastd_backbone = '/usr/local/bin/ffffm-update-fastd-backbone'

  file { '/etc/cron.d/fastd':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    content => template('fastd/fastd-cron.erb'),
    mode    => '0755',
  }

  file { $update_fastd_backbone:
    ensure => file,
    mode   => '0755',
    owner  => 'root',
    group  => 'root',
    source => 'puppet:///modules/fastd/update-fastd-backbone.sh',
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
