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

  if $title !~ /@$/ {
    Systemd::Unit["${title}.timer"] ~> Service[$title]
    Exec[$systemd::reload_command] -> Service[$title]
  }
