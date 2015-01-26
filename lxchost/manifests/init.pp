# == Class: lxchost
#
# Full description of class lxchost here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if it
#   has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should not be used in preference to class parameters  as of
#   Puppet 2.6.)
#
# === Examples
#
#  class { lxchost:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ]
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2011 Your name here, unless otherwise noted.
#
class lxchost {
  include apt
  class { 'batman':
    ipv4_suffix       => $ipv4_suffix,
    ipv4_subnet_start => $ipv4_subnet_start,
    ipv6_subnet       => $ipv6_subnet,
  }
  include puppet
  include rsyslog
  include sources_apt
  class { 'collectd':
    supernodenum => $::supernodenum,
  }

#  class { 'tinc':
#    backbone_ip_suffix  => $backbone_ip_suffix,
#    ipv4_subnet_start   => $ipv4_subnet_start,
#    ipv6_subnet         => $ipv6_subnet,
#  }
#  include unbound
  include postfix

  class { 'fastd':
#    eigene_ipv4ip_start            => $ipv4_subnet_start,
#    ipv4_suffix                    => $ipv4_suffix,
    supernodenum            => $::supernodenum,
    fastd_key               => $::fastd_key,
    ipv6_net                => "$ipv6_net",
    ipv6_rnet                => "$ipv6_rnet",
    ipv6_rnet_prefix    => "$ipv6_rnet_prefix",
    ipv6_rnet_mask      => "$ipv6_rnet_mask",
  }


  service { 'ssh':
    ensure => running,
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
}
