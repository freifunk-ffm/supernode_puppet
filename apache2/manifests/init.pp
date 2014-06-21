class apache2 {
  package { 'apache2':
    ensure  => installed,
  }

  service { 'apache2':
    ensure  => running,
    enable  => true,
  }
}
