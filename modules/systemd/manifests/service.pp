define systemd::service (
  $ensure = undef,
  $source = undef,
  $content = undef,
) {
  include systemd

  systemd::unit { "${title}.service":
    ensure  => $ensure,
    source  => $source,
    content => $content,
  }

  Service <| title == $title |> {
    provider => 'systemd',
  }

  Exec[$systemd::reload_command] ~> Service[$title]
}
