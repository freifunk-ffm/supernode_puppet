define fastd::variant (
  $port,
  $mtu,
  $pmtu,
) {
  include ::fastd

  $interface = $title
  $socket = "/var/run/fastd-${interface}.sock"

  $service = $::fastd::service
  $user = $::fastd::user
  $fastd_key = $::fastd::fastd_key
  $ipv6_net = $::fastd::ipv6_net
  $ipv6_rnet = $::fastd::ipv6_rnet
  $ipv6_rnet_prefix = $::fastd::ipv6_rnet_prefix
  $ipv6_rnet_mask = $::fastd::ipv6_rnet_mask
  $rndmac = $::fastd::rndmac
  $web_service_auth = $::fastd::web_service_auth

  $dir = "/etc/fastd/${title}/"

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
    "${dir}/on-establish":
      content => template('fastd/on-establish.erb');
    "${dir}/on-disestablish":
      content => template('fastd/on-disestablish.erb');
    "${dir}/verify":
      content => template('fastd/verify.erb');
    "${dir}/fastd.conf":
      mode    => '0644',
      content => template('fastd/fastd.conf.erb');
    "${dir}/backbone":
      ensure => symlink,
      target => '../blacklist';
  }
}
