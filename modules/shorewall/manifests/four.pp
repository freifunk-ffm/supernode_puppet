class shorewall::four {
  $basedir = '/etc/shorewall'
  $package = 'shorewall'
  $service = 'shorewall'
  $config = 'shorewall.conf'

  shorewall::instance { 'four':
    basedir => $basedir,
    package => $package,
    service => $service,
    config  => $config,
  }
}
