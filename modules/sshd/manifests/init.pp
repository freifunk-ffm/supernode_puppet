class sshd {
  package { 'openssh-server':
    ensure => installed,
  }

  service { 'ssh':
    ensure  => running,
    require => Package['openssh-server'],
  }

  File {
    owner => 'root',
    group => 'root',
  }

  file { '/root/.ssh':
    ensure => directory,
    mode   => '0700',
  }
  
  file { '/root/.ssh/authorized_keys':
    ensure  => file,
    content => template('sshd/authorized_keys.erb'),
    mode    => '0600',
  }

  file { '/etc/ssh/sshd_config':
    ensure  => file,
    content => template('sshd/sshd_config.erb'),
    require => Package['openssh-server'],
    notify  => Service['ssh'],
  }

}

