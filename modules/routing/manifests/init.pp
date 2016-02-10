class routing {
  # FIXME really replace the whole file?
  file { '/etc/iproute2/rt_tables':
    content => template('routing/rt_tables'),
  }
}
