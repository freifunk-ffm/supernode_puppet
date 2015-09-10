class logrotate {
  package { 'logrotate':
    ensure => installed,
  }
}
