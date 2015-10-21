class ffmff::dns_server {
  $package = 'bind9'
  $service = 'bind9'

  include dns_repo

  package { $package:
    ensure => present,
  }

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package[$package],
    notify  => Service[$service],
  }

  file {
    '/etc/named/named.conf':
      source => 'puppet:///modules/ffmff/dns_server/named.conf';
    '/etc/named/zones.ffm':
      source => 'puppet:///modules/ffmff/dns_server/zones.ffm';
    '/etc/named/zones.ff':
      ensure => link,
      target => '/var/lib/ffmff/output/zones.ff';
  }

  service { $service:
    ensure => running,
    enable => true,
  }
}
