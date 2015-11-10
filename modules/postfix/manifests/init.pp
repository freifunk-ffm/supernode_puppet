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
  $mailrelay_user = $::hostname
  $trocla_key = "mail/${mailrelay_user}/password"
  $mailrelay_password = trocla($trocla_key)
  $mailrelay_host = 'mail.bb.ffm.freifunk.net'

  file { $postfix_sasl_passwds:
    ensure  => file,
    owner   => 'root',
    group   => 'postfix',
    mode    => '0640',
    content => "[${mailrelay_host}] ${mailrelay_user}:${mailrelay_password}",
  }

  exec { "/usr/sbin/postmap ${postfix_sasl_passwds}":
    onlyif  => "/usr/bin/test ${postfix_sasl_passwds} -nt ${postfix_sasl_passwds}.db",
    require => File[$postfix_sasl_passwds],
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
}
