class ffmff::lxchost {
  include ffmff

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
