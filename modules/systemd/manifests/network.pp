define systemd::network (
  $ensure = undef,
  $source = undef,
  $content = undef,
) {
  include systemd

  systemd::unit { "${title}.network":
    type    => 'network',
    ensure  => $ensure,
    source  => $source,
    content => $content,
  }
}
