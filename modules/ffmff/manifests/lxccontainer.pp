class ffmff::lxccontainer {
  include ffmff

  package { [
    'denyhosts', 'iptables', 'screen',
  ]:
    ensure => installed,
  }

  file_line { 'prefer_ipv4':
    path => '/etc/gai.conf',
    line => 'precedence ::ffff:0:0/96  100',
  }
}
