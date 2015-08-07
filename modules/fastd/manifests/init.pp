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
  $web_service_auth,
) {
  $user = 'fastd_serv'
  $service = 'fastd'

  package { [
    'fastd', 'bridge-utils', 'curl',
  ]:
    ensure  => installed,
  }

  include git

  user { $user:
    ensure     => present,
    shell      => '/bin/bash',
    home       => '/home/fastd_serv',
    managehome => true,
  }

  service { $service:
    ensure  => running,
    enable  => true,
    require => [
      Package['fastd'],
      Package['bridge-utils'],
      Package['curl'],
    ],
  }

  file { '/etc/fastd':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    before  => [Exec['fastd_backbone'], Exec['fastd_blacklist']],
    require => Package['fastd'],
  }

  file { '/etc/cron.d/fastd':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    content => template('fastd/fastd-cron.erb'),
    mode    => '0755',
  }

  # FIXME do this on each node or only on the puppetmaster?
  exec { 'fastd_blacklist':
    command => '/usr/bin/git clone https://github.com/freifunk-ffm/fastd-backbone-config /etc/fastd/blacklist',
    require => Package['git'],
  }

  Vcsrepo {
    ensure   => present,
    require  => Class['git'],
    provider => 'git',
  }

  vcsrepo { '/etc/fastd/blacklist':
    source => 'https://github.com/freifunk-ffm/fastd-backbone-config';
  }
}
