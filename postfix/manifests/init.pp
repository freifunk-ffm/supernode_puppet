class postfix ($fastd_key, $fastd_num) {
  package { 'postfix': ensure => installed, }
  package { 'pwgen': ensure => installed, }

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
  #"[mail.bb.ffm.freifunk.net] user:pass; postmap file
  exec { 'openvpn_config_6':
  command => 'pw=$(pwgen 10); /bin/echo "[mail.bb.ffm.freifunk.net]  fastd$fastd_num:$pw" >> /etc/postfix/sasl_passwd; postmap /etc/postfix/sasl_passwd; /bin/echo "MAKE SURE TO ADD fastd$fastd_num:$pw on mail.bb.ffm.freifunk.net TO /etc/postfix/sasld_passwd',
      unless  => '/bin/grep "mail.bb.ffm.freifunk.net" /etc/postfix/sasl_passwd',
  }

}
