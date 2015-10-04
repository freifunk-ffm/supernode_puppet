class ff_tools {
  include git

  vcsrepo { '/root/ff-tools':
    ensure   => present,
    provider => 'git',
    source   => 'https://github.com/ffrl/ff-tools.git',
    require  => Class['git'],
  }

  package { [
    'wget', 'python-hurry.filesize', 'python-pip',
  ]:
    ensure => installed,
  }

  package { 'npyscreen':
    ensure   => '4.8.7',
    provider => 'pip',
    require  => Package['python-pip'],
  }
}
