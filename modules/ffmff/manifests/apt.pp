class ffmff::apt {
  $release = $::lsbdistcodename
  $repos = ['main']

package { ['apt-transport-https']: ensure => installed }
  class { '::apt':
    purge => {
      'sources.list.d' => true,
      'sources.list' => true,
      'preferences' => true,
      'preferences.d' => true,
    }
  }

  apt::conf { 'disable_install_recommends':
    ensure  => present,
    content => "APT::Install-Recommends \"0\";\nAPT::Install-Suggests \"0\";",
  }

  Apt::Source {
    include => {
      'deb' => true,
      'src' => true,
    },
    repos => join($repos, ' '),
  }

  apt::source { 'debian':
    location => 'http://mirrors.kernel.org/debian',
    release  => $release,
  }

  apt::source { 'updates':
    location => 'http://mirrors.kernel.org/debian',
    release  => "${release}-updates",
  }

  # Do not use apt::backports, as this pins the origin.
  # As we use the same origin for everything, that brakes pins
  apt::source { 'backports':
    location => 'http://mirrors.kernel.org/debian',
    release  => "${release}-backports",
  }

  apt::source { 'security':
    location => 'http://security.debian.org',
    release  => "${release}/updates",
  }

  ::apt::source { 'universe_factory':
    location => 'http://repo.universe-factory.net/debian/',
    release  => 'sid',
    include  => {
      'deb' => true,
      'src' => false,
    },
    key      => {
      id     => '6664E7BDA6B669881EC52E7516EF3F64CB201D9C',
      server => 'pgp.mit.edu',
    },
  }

  include ::unattended_upgrades
}
