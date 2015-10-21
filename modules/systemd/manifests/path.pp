define systemd::path (
  $ensure = undef,
  $source = undef,
  $content = undef,
) {
  systemd::unit { "${title}.path":
    ensure  => $ensure,
    source  => $source,
    content => $content,
  }
}
