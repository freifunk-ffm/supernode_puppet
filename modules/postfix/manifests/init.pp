class postfix () {
  package { 'postfix':
    ensure => installed,
  }

  service { 'postfix':
    ensure  => running,
    enable  => true,
    require => Package['postfix'],
  }

  file { '/etc/postfix':
    ensure  => directory,
    require => Package['postfix'],
  }

  file { '/etc/postfix/main.cf':
    ensure  => file,
    content => template('postfix/main.cf.erb'),
    notify  => Service['postfix'],
  }

  #"[mail.bb.ffm.freifunk.net] user:pass; postmap file
  $postfix_sasl_passwds = '/etc/postfix/sasl_passwd'
  $random_passwd = ffmff_random_string(10)

  file { $postfix_sasl_passwds:
    ensure => file,
  }

  file_line { 'postfix_sasl_passwd':
    path    => $postfix_sasl_passwds,
    match   => '^\[mail.bb.ffm.freifunk.net\]',
    replace => false,
    line    => "[mail.bb.ffm.freifunk.net] ${::hostname}:${random_passwd}",
  }

  exec { "/usr/sbin/postmap ${postfix_sasl_passwds}":
    onlyif  => "/usr/bin/test ${postfix_sasl_passwds} -nt ${postfix_sasl_passwds}.db",
    require => File_line['postfix_sasl_passwd'],
    notify  => Service['postfix'],
  }

  file_line { '/etc/aliases:root':
    line => 'root: admin@ffm.freifunk.net',
    path => '/etc/aliases',
  }

  exec { '/usr/bin/newaliases':
    onlyif  => '/usr/bin/test /etc/aliases -nt /etc/aliases.db',
    require => File_line['/etc/aliases:root'],
    notify  => Service['postfix'],
  }
warning ("MAKE SURE TO run doveadm pw -ssha enter the PASSWORD and put '${::hostname}' into /etc/dovecot/passwd on mail.bb.ffm.freifunk.net")

}
