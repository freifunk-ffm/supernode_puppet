define systemd::netdev (
  $ensure = undef,
  $source = undef,
  $content = undef,
) {
  include systemd

  systemd::unit { "${title}.netdev":
    type    => 'network',
    ensure  => $ensure,
    source  => $source,
    content => $content,
  }
}
