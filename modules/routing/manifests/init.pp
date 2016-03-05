class routing {
  # FIXME really replace the whole file?
  file { '/etc/iproute2/rt_tables':
    content => '200 ffffm',
  }
  file { '/usr/local/bin/directexit':                                         
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    content => template('routing/directexit'),
    mode    => '0755',
  }

}
