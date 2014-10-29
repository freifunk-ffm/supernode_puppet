class postfix ($fastd_key) {
  package { 'postfix': ensure => installed, }
  service { 'postfix':
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus => false,
    require => Package['postfix'],
  }
  file { 'main-cf':
    ensure => file,
    path => '/etc/postfix/main.cf',
    content => template('postfix/main.cf.erb'),
    notify => Service['tinc'],
  }
}
