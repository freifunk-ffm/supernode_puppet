define systemd::unit (
  $ensure = present,
  $source = undef,
  $content = undef,
  $type = 'system',
) {
  include systemd

  $file = "/etc/systemd/${type}/${title}"

  file { $file:
    ensure  => $ensure,
    source  => $source,
    content => $content,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    notify  => $systemd::reload,
  }

  case $type {
    'system': {
      File[$file] ~> Exec[$systemd::reload_command]
    }
    'network': {
      include systemd::networkd
      File[$file] ~> Service[$systemd::networkd::service]
    }
    default: {
      fail()
    }
  }
}
