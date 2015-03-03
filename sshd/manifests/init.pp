class sshd {

  package { 'openssh': ensure => installed, }
  service { 'ssh':
    ensure => running,
  }

  file { '/root/.ssh':
    ensure => directory,
    mode => 0700,
  }
  
  file { 'keys':
    ensure => file,
    path => '/root/.ssh/authorized_keys',
    content => template('sshd/authorized_keys.erb'),
    mode => 0600,
#    notify => Service['tinc'],
  }

  file { 'config':
    ensure => file,
    path => '/etc/ssh/sshd_config',
    content => template('sshd/sshd_config.erb'),
#    notify => Service['tinc'],
  }

}

