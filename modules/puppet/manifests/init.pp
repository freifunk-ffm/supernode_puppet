class puppet {
  # FIXME what about the configuration?

  package {[
    'libaugeas0', 'augeas-lenses', 'augeas-tools', 'libaugeas-ruby',
  ] :
    ensure => installed,
    before => Service['puppet'],
  }

  service { 'puppet':
    ensure => running,
    enable => true,
  }

}
