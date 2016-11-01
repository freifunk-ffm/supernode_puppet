class routing {
  # FIXME really replace the whole file?
  $user = 'root'
  $group = $user
  package { 'ipset':
    ensure => installed,
  }
  package { 'jq':
    ensure => installed,
  }

  file { '/etc/iproute2/rt_tables':
    content => template('routing/rt_tables'),
  }

  $update_directexit = '/usr/local/bin/directexit'
  file { $update_directexit:
    ensure  => file,
    owner   => $user,
    group   => $group,
    content => template('routing/directexit'),
    mode    => '0755',
  }

  systemd::service { 'update-directexit':
    content => template('routing/update-directexit.service'),
  }

  systemd::timer { 'update-directexit':
    content => template('routing/update-directexit.timer'),
  }

  service { 'update-directexit.timer':
    ensure  => running,
    enable  => true,
  } ->

  service { 'update-directexit':
    ensure  => running,
    enable  => true,
  }

  cron { 'update-directexit':
    ensure   => absent,
  }
}
