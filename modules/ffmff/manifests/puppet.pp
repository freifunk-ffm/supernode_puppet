class ffmff::puppet (
  $master = false,
) {
  validate_bool($master)

  class { '::puppet':
    server                        => $master,
    server_foreman                => false,
    server_passenger              => false,
    server_storeconfigs_backend   => 'puppetdb',
    server_directory_environments => true,
    server_git_repo               => true,
    server_puppetdb_host          => '127.0.0.1',
    server_external_nodes         => false,
  }

  file { '/etc/puppetlabs':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  if $master {
    file { '/etc/puppetlabs/puppetdb':
      ensure => link,
      target => '/etc/puppetdb',
    }

    class { '::puppetdb':
      manage_package_repo => false,
    }

    class { '::puppetdb::master::config': }
  }
}
