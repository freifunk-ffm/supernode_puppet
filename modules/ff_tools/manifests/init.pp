class ff_tools {
  include git

  vcsrepo { '/root/ff-tools':
    ensure   => present,
    provider => 'git',
    source   => 'https://github.com/ffrl/ff-tools.git',
    require  => Class['git'],
  }

  package { [
    'wget', 'python-hurry.filesize',
  ]:
    ensure => installed,
  }

  exec { 'dlnpyscreen':
    command => '/usr/bin/wget -O /root/npyscreen-4.8.7.tar.gz https://pypi.python.org/packages/source/n/npyscreen/npyscreen-4.8.7.tar.gz',
    creates => '/root/npyscreen-4.8.7.tar.gz',
    require => Package['wget'],
  } ->

  exec {'installnpyscreen':
    command => '/bin/tar xaf /root/npyscreen-4.8.7.tar.gz',
    creates => '/root/npyscreen-4.8.7/setup.py',
    notify  => Exec['installnpyscreen1'],
  } ->

  exec {'installnpyscreen1':
    command => '/usr/bin/python /root/npyscreen-4.8.7/setup.py install',
    creates => '/usr/local/lib/python2.7/dist-packages/npyscreen-4.8.7.egg-info',
    require => Exec['installnpyscreen'],
  }
}

