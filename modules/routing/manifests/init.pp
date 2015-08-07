class routing {
  exec { 'ffkbu':
    command => '/bin/echo "200 ffffm" > /etc/iproute2/rt_tables',
    unless  => '/bin/grep "200 ffffm" /etc/iproute2/rt_tables',
  }
}
