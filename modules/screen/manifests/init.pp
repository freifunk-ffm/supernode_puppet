class screen {
  package { 'screen':
    ensure  => installed,
  }

  file { '/root/.screenrc':
    ensure  => file,
    content => template('screen/screenrc.erb'),
    require => Package['screen'],
  }
}
