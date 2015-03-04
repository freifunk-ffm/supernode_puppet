# == Class: lxchost
# === Examples
#
#  class { lxchost:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
class lxccontainer {
  include apt
  include puppet
  include rsyslog
  include sources_apt
  include postfix

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
  package { 'iptables': 
    ensure => installed, 
  }
  service { 'ssh':
    ensure => running,
  }
  package { 'ntp':
    ensure  => installed,
  }
  package { 'vim':
    ensure  => installed,
  }
  package { 'lxc':
    ensure  => installed,
  }
  package { 'screen':
    ensure  => installed,

  }
  exec { 'firewall':
    command => '/bin/sed "s|exit|/etc/fw/*.fw;exit|" -i /etc/rc.local',
    path => "['/usr/bin','/bin', '/usr/sbin']",
    unless  => '/bin/grep /etc/fw/ /etc/rc.local'
  }
  exec { 'prefer ipv4':
    command => 'echo "precedence ::ffff:0:0/96  100" >>/etc/gai.conf',
    path => "['/usr/bin','/bin', '/usr/sbin']",
    unless => '/bin/grep "^precedence ::ffff:0:0/96  100" /etc/gai.conf'
  }
}
