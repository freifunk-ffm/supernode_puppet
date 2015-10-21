class ffmff::dns_server {
  $package = 'bind9'
  $service = 'bind9'
  $user = 'bind'

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
    '/etc/bind/named.conf':
      source => 'puppet:///modules/ffmff/dns_server/named.conf';
    '/etc/bind/zones.ffm':
      source => 'puppet:///modules/ffmff/dns_server/zones.ffm';
    '/etc/bind/zones.ff':
      ensure => link,
      target => '/var/lib/ffmff/output/zones.ff';
    '/etc/bind/master':
      ensure => directory,
      mode   => '0750',
      owner  => $user,
  }

  service { $service:
    ensure => running,
    enable => true,
  }

  systemd::service { 'reload-bind':
    ensure => present,
    source => 'puppet:///modules/ffmff/dns_server/reload-bind.service',
  }

  systemd::path { 'reload-bind':
    ensure => present,
    source => 'puppet:///modules/ffmff/dns_server/reload-bind.path',
  } ~>

  service { 'reload-bind.path':
    ensure => running,
    enable => true,
  }
}
