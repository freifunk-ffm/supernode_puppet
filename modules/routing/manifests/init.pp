class routing {
  # FIXME really replace the whole file?
  file { '/etc/iproute2/rt_tables':
    content => '200 ffffm',
  }
}
