class ffmff::supernode (
  $supernodenum,
  $fastd_key,
  $rndmac,
) {
  validate_integer($supernodenum, 20, 1)

  include ffmff

  # packages

  package { [
    'xinetd', 'monitoring-plugins', 'check-mk-agent', 'nagios-nrpe-server',
  ]:
    ensure => installed,
  }

  Class['apt::update'] -> Package['check-mk-agent']
  include ffmff::chronic

  file {
    'check_vpn':
      ensure => file,
      path => '/root/check_vpn',
      content => template('ffmff/supernode/check_vpn.erb'),
      mode => '0755';
    'check_vpn-cron':
      ensure => file,
      path => '/etc/cron.d/check_vpn',
      content => template('ffmff/supernode/check_vpn-cron.erb'),
      mode => '0755';
    '/root/testmessage':
      ensure => file,
      path => '/root/testmessage',
      content => template('ffmff/supernode/testmessage.erb'),
      mode => '0644';
  }

  $ipv4_subnet_start  = 8 * ($supernodenum - 1)
  $ipv4_subnet_end    = (8 * $supernodenum) - 1

  $ipv4_suffix = $supernodenum ? {
    1       => 3,
    default => 1,
  }

  # FIXME move to params
  $ipv4_net = '10.126'
  $ipv6_rnet_prefix = 'fddd:5d16:b5dd:'
  $ipv6_rnet_mask = 64

  $ipv6_subnet        = '0'
  $ipv6_net = "${ipv6_net_prefix}${ipv6_subnet}"
  $ipv6_rnet = "${ipv6_rnet_prefix}${ipv6_subnet}"
  $backbone_ip_suffix = $supernodenum + 20

  class { 'batman':
    ipv4_suffix       => $ipv4_suffix,
    ipv4_subnet_start => $ipv4_subnet_start,
  }

  validate_integer($supernodenum)
  $gateway_router_host = $supernodenum ? {
    1       => 3,
    default => 1,
  }

  class { 'dhcpd':
    gateway_router_host => $gateway_router_host,
    ipv4_subnet_start   => $ipv4_subnet_start,
    ipv4_subnet_end     => $ipv4_subnet_end,
  }

  class { 'fastd':
    supernodenum      => $supernodenum,
    fastd_key         => $fastd_key,
    ipv4_net          => $ipv4_net,
    ipv4_subnet_start => $ipv4_subnet_start,
    ipv4_suffix       => $ipv4_suffix,
    ipv6_net          => $ipv6_net,
    ipv6_rnet         => $ipv6_rnet,
    ipv6_rnet_prefix  => $ipv6_rnet_prefix,
    ipv6_rnet_mask    => $ipv6_rnet_mask,
    rndmac            => $rndmac,
  }

  fastd::variant {
    'mesh-vpn':
# backbone-Netz in dem ausschliesslich server liegen, Vollvermaschung
# nur mit key authentifizierte hosts zulassen
      nullcipher        => true,
      mtu               => 1426,
      port              => 10000,
      pmtu              => false,
      peerlimit		=> 999999,
      macvendor		=> '02:ff:0f',
      backbone => true;
    'mesh-vpn-1280':
      nullcipher        => true,
      mtu               => 1280,
      port              => 10001,
      pmtu              => false,
      peerlimit		=> 220,
      macvendor		=> '02:ff:1f',
      backbone => false;
    'mesh-vpn-1426':
      nullcipher        => true,
      mtu               => 1426,
      port              => 10002,
      pmtu              => false,
      peerlimit		=> 220,
      macvendor		=> '02:ff:2f',
      backbone => false;
  }

  include ff_tools

  class { 'radvd':
    ipv6_subnet => $ipv6_subnet,
    ipv6_net    => $ipv6_net,
    ipv6_rnet   => $ipv6_rnet,
  }

  include routing
  include sysctl_conf
  include openvpn

  class { 'collectd':
    supernodenum => $supernodenum,
  }

  include ffmff::dns_server

  systemd::netdev {
    'local-gate':
      source => 'puppet:///modules/ffmff/local-gate.netdev';
  }

  systemd::network {
    'local-gate':
      source => 'puppet:///modules/ffmff/local-gate.network';
    'bat0':
      source => 'puppet:///modules/ffmff/supernode/bat0.network';
  }

  # fix dependency cycle
  service { 'rpcbind':
    ensure => stopped,
    enable => false,
  }

  systemd::service { 'setup-ipsets':
    source => 'puppet:///modules/ffmff/supernode/setup-ipsets.service';
  }

  service { 'setup-ipsets':
    ensure => running,
    enable => true,
  }

  systemd::service {
    'shorewall':
      source => 'puppet:///modules/ffmff/systemd/units/shorewall.service';
    'shorewall6':
      source => 'puppet:///modules/ffmff/systemd/units/shorewall6.service';
  }

  service { [
    'shorewall',
    'shorewall6',
  ]:
    ensure => stopped,
    enable => false,
  }

  shorewall::four::zone { [
    'net',
    'ovpn',
    'fastd',
    'users',
    #    'bat',
  ]: }
  shorewall::four::zone { 'fw':
    type => 'firewall',
  }
  include shorewall::symlink::zones

  shorewall::four::interface {
    'eth0':
      zone => 'net';
    ['mesh-vpn', 'mesh-vpn-+']:
      zone => 'fastd';
    'ovpn-inet':
      zone => 'ovpn';
    ['batbridge', 'local-gate']:
      zone => 'users';
  }
  include shorewall::symlink::interfaces

  shorewall::four::policy {
    'outbound':
      source => '$FW',
      dest   => 'all',
      policy => 'ACCEPT',
      order  => 1;
    'default':
      source    => 'all',
      dest      => 'all',
      policy    => 'REJECT',
      log_level => 'info',
      order     => 999,
  }
  include shorewall::symlink::policy

  Shorewall::Four::Rule {
    section => 'NEW',
    action  => 'ACCEPT',
  }

  shorewall::four::rule {
    'ssh':
      order  => 1,
      source => 'all',
      dest   => 'all', # $FW?
      proto  => 'tcp',
      dport  => 'ssh';
    'ping':
      order  => 2,
      source => 'all',
      dest   => 'all', # $FW?
      proto  => 'icmp',
      dport  => 8;
    'dns':
      order  => 3,
      source => 'client',
      dest   => '$FW',
      proto  => ['udp', 'tcp'],
      dport  => 'domain';
    'nagios':
      order  => 4,
      source => 'net:130.180.93.142',
      dest   => '$FW',
      proto  => 'tcp',
      dport  => [6556, 5666];
    'foo1':
      order  => 5,
      source => 'client',
      dest   => '$FW',
      proto  => 'tcp',
      dport  => 3000;
    'foo2':
      order  => 6,
      source => 'client:10.126.255.25',
      dest   => '$FW',
      proto  => 'tcp',
      dport  => [6556,5666];
    'dhcp':
      order  => 7,
      source => 'client',
      dest   => '$FW',  # all?
      proto  => 'udp',
      dport  => [67, 68];
    'fastd':
      order  => 8,
      source => 'net',
      dest   => '$FW',  # all?
      proto  => 'udp',
      dport  => '10000:10002';
    'allow local exit':
      order  => 99,
      source => 'users',
      dest   => 'net:+exit';
  }

  shorewall::four::mangle {
    'mark local exit':
      order  => 1,
      action => 'MARK(0x1)',
      dest   => '+exit';
  }

  shorewall::four::masq {
    'ovpn-inet':
      order     => 1,
      interface => 'ovpn-inet',
      source    => '10.126.0.0/16',
      # address => '138.201.45.136',
      # 1.1.1.1?
  }
}
