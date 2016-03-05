class routing {
  # FIXME really replace the whole file?
  package { 'ipset':
    ensure => installed,
  }
  package { 'jq':
    ensure => installed,
  }


  file { '/etc/iproute2/rt_tables':
    content => template('routing/rt_tables'),
  }
  file { '/usr/local/bin/directexit':                                         
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    content => template('routing/directexit'),
    mode    => '0755',
  }

}
