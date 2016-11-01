define systemd::timer (
  $ensure = undef,
  $source = undef,
  $content = undef,
) {
  include systemd

  systemd::unit { "${title}.timer":
    ensure  => $ensure,
    source  => $source,
    content => $content,
  }

  Service <| title == "${title}.timer" |> {
    provider => 'systemd',
  }

  if $title !~ /@$/ {
    Systemd::Unit["${title}.timer"] ~> Service[$title]
    Exec[$systemd::reload_command] -> Service[$title]
  }
}
