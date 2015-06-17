class ff-tools () {

  exec { 'getfftools':
    command => '/usr/bin/git clone https://github.com/ffrl/ff-tools.git /root/ff-tools',
    notify  => Exec['dlnpyscreen'],
    require => Package['git'],
  }
  package {'python-hurry.filesize':
    ensure => installed,
  }

  exec { 'dlnpyscreen':
    command => 'wget -O /root/npyscreen-4.8.7.tar.gz https://pypi.python.org/packages/source/n/npyscreen/npyscreen-4.8.7.tar.gz',
    notify => Exec['installnpyscreen'],
    require => Package['wget'],
  }
exec {'installnpyscreen':
  command=> 'tar xaf /root/npyscreen-4.8.7.tar.gz',
  notify => Exec['installnpyscreen1'],
  require => Exec['dlnpyscreen'],
}
exec {'installnpyscreen1':
  command => 'python /root/npyscreen-4.8.7/setup.py install',
  require => Exec['installnpyscreen'],
  }
 
  exec { 'installfftools':
    command => 'python /root/ff-tools/setup.py install'
    require => [Exec['getfftools'], Exec['installnpyscreen1']],
  }
 
  exec { 'fastd_backbone':
    command => '/usr/bin/git clone https://github.com/freifunk-ffm/fastd-backbone-config \
/etc/fastd/mesh-vpn/backbone',
    creates => '/etc/fastd/mesh-vpn/backbone', 
    require => Package['git'],
  }
}

