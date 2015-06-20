class ff-tools () {

  exec { 'getfftools':
    command => '/usr/bin/git clone https://github.com/ffrl/ff-tools.git /root/ff-tools',
    require => [Package['python-hurry.filesize'],Package['git'],Exec['fastd_backbone']],
  }
  package {'wget':
	ensure => installed,
	}

  package {'python-hurry.filesize':
    ensure => installed,
  }

  exec { 'dlnpyscreen':
    command => '/usr/bin/wget -O /root/npyscreen-4.8.7.tar.gz https://pypi.python.org/packages/source/n/npyscreen/npyscreen-4.8.7.tar.gz',
    require => Package['wget'],
  }
  exec {'installnpyscreen':
    command=> '/bin/tar xaf /root/npyscreen-4.8.7.tar.gz',
    notify => Exec['installnpyscreen1'],
    require => Exec['dlnpyscreen'],
  }
  exec {'installnpyscreen1':
    command => '/usr/bin/python /root/npyscreen-4.8.7/setup.py install',
    require => Exec['installnpyscreen'],
  }
 
  exec { 'installfftools':
    command => '/usr/bin/python /root/ff-tools/setup.py install',
    require => [Exec['getfftools'], Exec['installnpyscreen1']],
  }
}

