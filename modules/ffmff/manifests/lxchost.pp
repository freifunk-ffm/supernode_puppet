class ffmff::lxchost (
    $lxcnum,
    $rndmac,
    ) 
{
  include ffmff

    package { [
      'git',  'iptables', 'lxc'
    ]:
    ensure => installed,
    }
  include sysctl_conf
  include ffmff::dns_server

    file_line { 'prefer_ipv4':
      path => '/etc/gai.conf',
      line => 'precedence ::ffff:0:0/96  100',
    }
    file { '/etc/modules-load.d/tun.conf':
      ensure => file,
      content => 'tun',
      owner => 'root',
      group => 'root',
      mode => '0644',
    }

}
