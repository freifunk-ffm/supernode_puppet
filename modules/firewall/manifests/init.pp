class firewall {
  $fqdn = $::trusted['certname']
  $fw_dir = '/etc/fw'
  $fw_file = "${fw_dir}/${fqdn}"
  $fw_link = "${fw_dir}/script"
  $service = 'fwbuilder'

  file { $fw_dir:
    ensure  => directory,
    mode    => '0755',
    group   => 'root',
    owner   => 'root',
    purge   => true,
    recurse => true,
    force   => true,
  }

  file { $fw_file:
    ensure => file,
    mode   => '0750',
    owner  => 'root',
    group  => 'root',
    source => "puppet:///modules/firewall/fwbuilder/${fqdn}.fw",
    notify => Service[$service],
  }

  file { $fw_link:
    ensure => link,
    target => $fw_file,
    notify => Service[$service],
  }

  file_line { '/etc/rc.local:firewall':
    ensure            => absent,
    path              => '/etc/rc.local',
    match             => '^/etc/fw/',
    line              => '',
    match_for_absence => true,
    multiple          => true,
    notify            => Service[$service],
    before            => Service['fail2ban'],
  }

  systemd::service { $service:
    ensure => present,
    source => 'puppet:///modules/firewall/fwbuilder.service'
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
