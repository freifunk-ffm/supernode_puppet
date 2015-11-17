class systemd {
  $reload_command = '/bin/systemctl daemon-reload'
  $reload = Exec[$reload_command]
  $unit_dir = '/etc/systemd/system'

  exec { $reload_command:
    refreshonly => true,
  }
}
