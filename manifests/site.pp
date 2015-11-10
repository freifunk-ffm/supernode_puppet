node 'puppet.ffm.freifunk.net' {
  class { 'ffmff::puppet':
    master => true,
  }
}
