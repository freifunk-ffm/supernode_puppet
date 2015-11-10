node 'puppet.ffm.freifunk.net' {
  class { 'ffmff':
    puppetmaster => true,
  }
}

node /fastd\d+\.ffm\.freifunk\.net/ {
  class { 'ffmff::supernode':
    supernodenum => 3,
    fastd_key    => '0000000000000000000000000000000000000000000000000000000000000000000',
    rndmac       => fqdn_rand(99)
  }
}
