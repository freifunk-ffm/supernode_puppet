class routing {
  # FIXME really replace the whole file?
  package { 'ipset':
    ensure => installed,
  }


  file { '/etc/iproute2/rt_tables':
    content => template('routing/rt_tables'),
  }
}
