class ffmff::puppet (
  $master = false,
) {
  validate_bool($master)

  apt::source { 'puppetlabs':
    location    => 'http://apt.puppetlabs.com',
    release     => $::lsbdistcodename,
    repos       => 'main dependencies',
    key         => '47B320EB4C7C375AA9DAE1A01054B7A24BD6EC30',
    key_content => file('ffmff/puppetlabs.asc'),
  }

  class { '::puppetdb::globals':
    version => '2.3.8-1puppetlabs1',
  }

  class { '::puppet':
    server                        => $master,
    server_foreman                => false,
    server_passenger              => false,
    server_storeconfigs_backend   => 'puppetdb',
    server_directory_environments => true,
    server_git_repo               => true,
    server_puppetdb_host          => 'puppet.ffm.freifunk.net',
    server_external_nodes         => '',
  }

  if $master {
    class { '::puppetdb':
      manage_package_repo => false,
    }
  }
}
