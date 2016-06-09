class shorewall::six {
  $basedir = '/etc/shorewall6'
  $package = 'shorewall6'
  $service = 'shorewall6'
  $config = 'shorewall6.conf'

  shorewall::instance { 'six':
    basedir => $basedir,
    package => $package,
    service => $service,
    config  => $config,
  }
}
