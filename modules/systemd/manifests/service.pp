define systemd::service (
  $ensure = undef,
  $source = undef,
  $content = undef,
) {
  systemd::unit { "${title}.service":
    ensure  => $ensure,
    source  => $source,
    content => $content,
  }

  Systemd::Unit["${title}.service"] ~> Service[$title]
}
