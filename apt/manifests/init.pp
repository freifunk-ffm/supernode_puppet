class apt{
  package { 'unattended-upgrades':
    ensure  => installed,
  }

  file { 'aptautoupdate':
    path    => '/etc/apt/apt.conf.d/20auto-upgrades',
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => 'APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
',
  }
}
