define systemd::unit (
  $ensure = present,
  $source = undef,
  $content = undef,
) {
  include systemd

  $file = "${systemd::unit_dir}/${title}"

  file { $file:
    ensure  => $ensure,
    source  => $source,
    content => $content,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    notify  => $systemd::reload,
  }

  File[$file] ~> Exec[$systemd::reload_command]
}
