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
#  $ipv6_net_prefix = '2001:1A50:11:4:'
  $ipv6_rnet_prefix = 'fddd:5d16:b5dd:'
# $ipv6_rnet_mask = 48
  $ipv6_rnet_mask = 64

  $ipv6_subnet        = sprintf('b1%02d', $supernodenum)
  $ipv6_net = "${ipv6_net_prefix}${ipv6_subnet}"
  $ipv6_rnet = "${ipv6_rnet_prefix}${ipv6_subnet}"
  $backbone_ip_suffix = $supernodenum + 20

  class { 'batman':
    ipv4_suffix       => $ipv4_suffix,
    ipv4_subnet_start => $ipv4_subnet_start,
    ipv6_subnet       => $ipv6_subnet,
  }

  class { 'dhcpd':
    supernodenum      => $supernodenum,
    ipv4_subnet_start => $ipv4_subnet_start,
    ipv4_subnet_end   => $ipv4_subnet_end,
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
      nullcipher        => false,
      mtu               => 1426,
      port              => 10000,
      pmtu              => false,
      use_backbone_repo => true;
    'mesh-vpn-1280':
      nullcipher        => true,
      mtu               => 1280,
      port              => 10001,
      pmtu              => false,
      use_backbone_repo => false;
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
}
