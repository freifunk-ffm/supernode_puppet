class ffmff::puppet (
  $master = false,
) {
  validate_bool($master)

  class { '::puppet':
    server                      => $master,
    server_foreman              => false,
    server_storeconfigs_backend => 'puppetdb',
  }

  if $master {
    class { '::puppetdb': }
  }
}
