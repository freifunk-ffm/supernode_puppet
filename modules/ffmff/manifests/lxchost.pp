class ffmff::lxchost {
  include ffmff

#  class { 'fastd':
#    eigene_ipv4ip_start            => $ipv4_subnet_start,
#    ipv4_suffix                    => $ipv4_suffix,
#    supernodenum            => $::supernodenum,
#    fastd_key               => $::fastd_key,
#    ipv6_net                => "$ipv6_net",
#    ipv6_rnet                => "$ipv6_rnet",
#    ipv6_rnet_prefix    => "$ipv6_rnet_prefix",
#    ipv6_rnet_mask      => "$ipv6_rnet_mask",
#  }

  package { [
    'git', 'vim', 'denyhosts', 'iptables', 'lxc', 'screen',
  ]:
    ensure => installed,
  }

  file_line { 'prefer_ipv4':
    path => '/etc/gai.conf',
    line => 'precedence ::ffff:0:0/96  100',
  }
}
