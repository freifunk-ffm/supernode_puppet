define fastd::variant (
  $nullcipher,
  $port,
  $mtu,
  $pmtu,
  $use_backbone_repo,
) {
  validate_integer($port)
  validate_integer($mtu)
  validate_bool($nullcipher, $pmtu, $use_backbone_repo)

  include ::fastd

  $interface = $title
  $socket = "/var/run/fastd-${interface}.sock"

  $service = "fastd@${title}"
  $user = $::fastd::user
  $fastd_key = $::fastd::fastd_key
  $ipv6_net = $::fastd::ipv6_net
  $ipv6_rnet = $::fastd::ipv6_rnet
  $ipv6_rnet_prefix = $::fastd::ipv6_rnet_prefix
  $ipv6_rnet_mask = $::fastd::ipv6_rnet_mask
  $rndmac = $::fastd::rndmac

  $dir = "/etc/fastd/${title}/"

  service { $service:
    ensure    => running,
    enable    => true,
    provider  => 'systemd',
    require   => Class['::fastd'],
    subscribe => File['/etc/systemd/system/fastd@.service'],
  }

  File {
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    notify  => Service[$service],
  }

  file {
    $dir:
      ensure  => directory,
      purge   => true,
      recurse => true,
      force   => true;
    "${dir}/peers":
      ensure  => directory,
      owner   => $user,
      group   => $user;
    "${dir}/fastd-up":
      content => template('fastd/fastd-up.erb');
    "${dir}/verify":
      content => template('fastd/verify.erb');
    "${dir}/fastd.conf":
      mode    => '0644',
      content => template('fastd/fastd.conf.erb');
  }

  if $use_backbone_repo {
    file { "${dir}/backbone":
      ensure => symlink,
      target => '../blacklist',
    }
  } else {
    file { "${dir}/backbone":
      ensure  => directory,
      purge   => true,
      recurse => true,
      force   => true,
    }
  }
}
