class systemd::networkd {
  $service = 'systemd-networkd'

  file { '/etc/systemd/network':
    ensure => directory,
    purge => true,
    recurse => true,
    force => true,
  }

  service { $service:
    ensure   => running,
    enable   => true,
    provider => 'systemd',
  }
}
