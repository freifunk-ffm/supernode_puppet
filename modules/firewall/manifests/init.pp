class firewall {
  $fqdn = $::trusted['certname']
  $fw_dir = '/etc/fw'
  $fw_file = "${fw_dir}/${fqdn}"
  $fw_link = "${fw_dir}/script"
  $service = 'shorewall'

  file_line { '/etc/rc.local:firewall':
    ensure            => absent,
    path              => '/etc/rc.local',
    match             => '^/etc/fw/',
    line              => '/etc/fw/foo',
    match_for_absence => true,
    notify            => Service[$service],
    before            => Service['fail2ban'],
  }

  service { $service:
    ensure => running,
    enable => true,
  }

  package { 'fail2ban':
    ensure => installed,
  }

  service { 'fail2ban':
    ensure  => running,
    enable  => true,
    require => Package['fail2ban'],
  }
}
