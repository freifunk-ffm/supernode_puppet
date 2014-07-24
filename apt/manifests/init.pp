class apt{
  file { 'aptautoupdate':
    path    => '/etc/apt/apt.conf.d/02autoupdate',
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 0644,
    content => 'APT::Periodic::Update-Package-Lists "1";',
  }
}
