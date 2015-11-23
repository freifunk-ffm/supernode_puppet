class mailserver {
  include mailserver::params

  service { 'dovecot':
    ensure => running,
    enable => true,
  }

  concat { $mailserver::params::generated_userdb:
    owner          => 'root',
    group          => 'dovecot',
    mode           => '0640',
    ensure_newline => true,
    notify         => Service['dovecot'],
  }

  Mailserver::Sasl_user <<||>>
}
