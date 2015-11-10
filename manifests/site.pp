node 'puppet.ffm.freifunk.net' {
  class { 'timezone':
    timezone => 'Etc/UTC',
  }

  class { 'locales':
    default_locale => 'en_US.UTF-8',
    locales        => [
      'en_US.UTF-8 UTF-8',
      'de_DE.UTF-8 UTF-8'
    ],
  }

  class { 'ffmff::puppet':
    master => true,
  }
}

node /fastd\d+\.ffm\.freifunk\.net/ {
  class { 'ffmff::supernode':
    supernodenum => 3,
    fastd_key    => '0000000000000000000000000000000000000000000000000000000000000000000',
    rndmac       => fqdn_rand(99)
  }
}
