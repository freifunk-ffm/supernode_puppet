class firewall {
  # FIXME use proper init script
  # FIXME remove check_presence

  file { '/etc/fw':
    ensure => directory,
    mode => 0755,
  }

  exec {'check_presence':
    command => '/bin/false',
    provider => shell,
    unless => '/usr/bin/test -f /etc/fw/$(hostname -f).fw',
  }

  file_line { '/etc/rc.local:firewall':
    path    => '/etc/rc.local',
    line    => '/etc/fw/*.fw; exit',
    match   => 'exit',
    before  => Service['fail2ban'],
    require => Exec["check_presence"],
  }

  package { 'fail2ban':
    ensure => installed,
  }

  service { 'fail2ban':
    ensure      => running,
    enable      => true,
    require     => Package['fail2ban'],
  }
}
