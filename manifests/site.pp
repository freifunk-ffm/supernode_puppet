node 'puppet.ffm.freifunk.net' {
  class { 'ffmff':
    puppetmaster => true,
  }
}
