class apache2 {
  package { 'apache2':
    ensure  => installed,
  }

  package { 'logrotate':
    ensure  => installed,
  }

  augeas { 'apache logrotate':
    context => '/files/etc/logrotate.d/apache2',
    changes => [
      'set rule/schedule "daily"',
      'set rule/rotate "7"',
    ],    
    require => [Package['apache2'], Package['logrotate']], 
  }

}
