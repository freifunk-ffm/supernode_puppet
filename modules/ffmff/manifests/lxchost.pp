class ffmff::lxchost (
    $lxcnum,
    $rndmac,
    ) 
{
  include ffmff

    package { [
      'git',  'iptables', 'lxc', 'screen'
    ]:
    ensure => installed,
    }
  include sysctl_conf
  include ffmff::dns_server

    file_line { 'prefer_ipv4':
      path => '/etc/gai.conf',
      line => 'precedence ::ffff:0:0/96  100',
    }
}
