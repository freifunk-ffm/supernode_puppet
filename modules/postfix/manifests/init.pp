class postfix () {
  $admin_mail = 'admin@ffm.freifunk.net'

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

  $trocla_key = "postfix/${::fqdn}/password"
  $sasl_password = trocla($trocla_key)
  $sasl_user = $::hostname

  @@mailserver::sasl_user { $sasl_user:
    trocla_key => $trocla_key,
  }

  file { $postfix_sasl_passwds:
    ensure  => file,
    owner   => 'root',
    group   => 'postfix',
    mode    => '0640',
    content => "[${mailrelay}] ${sasl_user}:${sasl_passwd}",
    notify  => Service['postfix'],
  }

  exec { "/usr/sbin/postmap ${postfix_sasl_passwds}":
    onlyif  => "/usr/bin/test ${postfix_sasl_passwds} -nt ${postfix_sasl_passwds}.db",
    require => File['postfix_sasl_passwd'],
    notify  => Service['postfix'],
  }

  file_line { '/etc/aliases:root':
    line   => 'root: admin@ffm.freifunk.net',
    path   => '/etc/aliases',
    notify => Exec['/usr/bin/newaliases'],
  }

  exec { '/usr/bin/newaliases':
    onlyif  => '/usr/bin/test /etc/aliases -nt /etc/aliases.db',
    require => File_line['/etc/aliases:root'],
    notify  => Service['postfix'],
  }

  $smtp_maps_file = '/etc/postfix/generic'

  file { $smtp_maps_file:
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => "@${::fqdn} ${admin_mail}",
  }

  exec { "/usr/sbin/postmap ${smtp_maps_file}":
    onlyif  => "/usr/bin/test ${smtp_maps_file} -nt ${smtp_maps_file}.db",
    require => File[$smtp_maps_file],
    notify  => Service['postfix'],
  }
}
