define shorewall::instance (
  $basedir,
  $package,
  $service,
  $config,
) {
  include shorewall

  package { $package:
    ensure => present,
  }

  file { $basedir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0750',
    purge   => true,
    recurse => true,
    force   => true,
    require => Package[$package],
    notify  => Service[$service],
  }

  file { [
    "${basedir}/${config}",
    # do we need this?
    "${basedir}/conntrack",
  ]:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    require => Package[$package],
    notify  => Service[$service],
  }

  service { $service:
    ensure => running,
    enable => true,
  }
}
