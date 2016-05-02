class ffmff::apt {
  class { '::apt':
    purge => {
      'sources.list.d' => true,
      'sources.list' => true,
      'preferences' => true,
      'preferences.d' => true,
    }
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

  include ::apt::backports
  include ::unattended_upgrades
}
