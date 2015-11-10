class ffmff::puppet (
  $master = false,
) {
  validate_bool($master)

    class { '::puppetdb::globals':
      version => '2.3.8',
    }

  class { '::puppet':
    server                        => $master,
    server_foreman                => false,
    server_passenger              => false,
    server_storeconfigs_backend   => 'puppetdb',
    server_directory_environments => true,
    server_git_repo               => true,
    server_puppetdb_host          => '127.0.0.1',
    server_external_nodes         => '',
  }

  if $master {
    class { '::puppetdb':
      manage_package_repo => false,
    }

    # class { '::puppetdb::master::config': }
  }
}
