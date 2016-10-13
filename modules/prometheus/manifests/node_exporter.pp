class prometheus::node_exporter (
  $diskstats_ignored_devices = undef,
) {
  $package = 'prometheus-node-exporter'
  $service = 'prometheus-node-exporter'
  $envvars = '/etc/default/prometheus-node-exporter'

  package { $package:
    ensure => present,
  } ->

  file { $envvars:
    ensure  => file,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    content => template('prometheus/prometheus-node-exporter.default'),
  } ~>

  service { $service:
    ensure => running,
    enable => true,
  }

  systemd::service { $service:
    content => 'puppet:///modules/prometheus/prometheus-node-exporter.service',
  }
}
