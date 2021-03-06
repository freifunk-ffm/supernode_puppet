class ffmff::dns_repo {
  $libdir = '/var/lib/ffmff'

  $user = 'ffmff'
  $group = $user

  user { $user:
    ensure => present,
    home   => $libdir,
    system => true,
  }

  group { $group:
    ensure  => present,
    system  => true,
    require => User[$user],
  }

  File {
    owner => $user,
    group => $group,
  }

  file {
    $libdir:
      ensure => directory;
    "${libdir}/output":
      ensure => directory;
    "${libdir}/.config":
      ensure => directory;
    "${libdir}/.config/git":
      ensure => directory;
    "${libdir}/.config/git/config":
      content => "[user]\nname = ffmff\nemail = admin@ffm.freifunk.net",
      ensure  => file;
  }

  Vcsrepo {
    ensure   => present,
    owner => $user,
    group => $group,
    provider => 'git',
  }

  vcsrepo {
    "${libdir}/icvpn-scripts.git":
      source => 'https://github.com/freifunk/icvpn-scripts.git';
    "${libdir}/icvpn-meta.git":
      source => 'https://github.com/freifunk/icvpn-meta.git';
  }

  $update_icvpn_zone = '/usr/local/bin/update-icvpn-zone'

  file { $update_icvpn_zone:
    ensure  => file,
    mode    => '0755',
    content => template('ffmff/update-icvpn-zone'),
  }

  include ffmff::chronic
  package { 'python3-yaml':
    ensure => present,
  }

  cron { 'update-icvpn-zone':
    command  => "/usr/bin/chronic ${update_icvpn_zone}",
    user     => $user,
    hour     => [02, 12],
    minute   => 0,
    month    => '*',
    monthday => '*',
    weekday  => '*',
  }
}
