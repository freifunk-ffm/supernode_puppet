class puppet {
  service { 'puppet':
    ensure    => running,
    hasstatus => true,
    hasrestart  => true,
    enable    => true,
    require   => [Package['libaugeas0'],Package['libaugeas-ruby']],
  }

  package { 'libaugeas0':
    ensure  => installed,
  }

  package { 'augeas-lenses':
    ensure  => installed,
  }

  package { 'augeas-tools':
    ensure  => installed,
  }

  package { 'libaugeas-ruby':
    ensure  => installed,
  }
}
