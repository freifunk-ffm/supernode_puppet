class systemd::networkd {
  $service = 'systemd-networkd'

  service { $service:
    ensure => running,
    enable => true,
  }
}
