define apt::key($keyid, $ensure, $keyserver = 'pgp.surfnet.nl') {
  case $ensure {
    present: {
      exec { "Import $keyid to apt keystore":
        path        => '/bin:/usr/bin',
        environment => 'HOME=/root',
        command     => "gpg --keyserver $keyserver --recv-keys $keyid && gpg --export --armor $keyid | apt-key add -",
        user        => 'root',
        group       => 'root',
        unless      => "apt-key list | grep $keyid",
        logoutput   => on_failure,
      }
    }
    absent:  {
      exec { "Remove $keyid from apt keystore":
        path        => '/bin:/usr/bin',
        environment => 'HOME=/root',
        command     => "apt-key del $keyid",
        user        => 'root',
        group       => 'root',
        onlyif      => "apt-key list | grep $keyid",
      }
    }
    default: {
      fail "Invalid 'ensure' value '$ensure' for apt::key"
    }
  }
}



class sources_apt {
  augeas { 'sources_universe':
    context => '/files/etc/apt/sources.list',
    changes => [
      'set 01/type deb',
      'set 01/uri "http://repo.universe-factory.net/debian/"',
      'set 01/distribution sid',
      'set 01/component main',
    ],
    onlyif  => 'match *[uri="http://repo.universe-factory.net/debian/"] size==0',
    require => Service['puppet'],
    notify  => Exec['apt-get update'],
  }

  apt::key { 'universe_factory':
    ensure  => present,
    keyid   => 'CB201D9C',
    notify  => Exec['apt-get update'],
    require => Augeas['sources_universe'],
  }

  exec { 'apt-get update':
    command     => '/usr/bin/apt-get update',
    require     => Apt::Key['universe_factory'],
    refreshonly => true,
  }
}
