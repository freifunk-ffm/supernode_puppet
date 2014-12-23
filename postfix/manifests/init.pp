class postfix ($fastd_key, $fastd_num) {
  package { 'postfix': ensure => installed, }
  package { 'pwgen': ensure => installed, }

  service { 'postfix':
    ensure => running,
    enable => true,
    hasrestart => true,
    hasstatus => false,
    require => [ Package['postfix'], Package['pwgen'] ],
  }
  file { 'main-cf':
    ensure => file,
    path => '/etc/postfix/main.cf',
    content => template('postfix/main.cf.erb'),
    notify => Service['tinc'],
  }
  #"[mail.bb.ffm.freifunk.net] user:pass; postmap file
  exec { 'postfix_config_6':
  command => '/bin/bash -lc "echo \"[mail.bb.ffm.freifunk.net]  fastd$fastd_num:$(/usr/bin/pwgen 10 -1)\" > /etc/postfix/sasl_passwd; /usr/sbin/postmap /etc/postfix/sasl_passwd;"',
  path => "['/usr/bin','/bin', '/usr/sbin']",
      unless  => '/bin/grep mail.bb.ffm.freifunk.net /etc/postfix/sasl_passwd'
  }
notify {"MAKE SURE TO ADD fastd$fastd_num:PASWORD (see /etc/postfix/sasl_passwd) to /etc/postfix/sasld_passwd on mail.bb.ffm.freifunk.net and run postmap /etc/postfix/sasld_passwd":}

}
