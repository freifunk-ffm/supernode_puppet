class ffmff::puppet (
  $master = false,
) {
  validate_bool($master)

  apt::source { 'puppetlabs':
    location    => 'http://apt.puppetlabs.com',
    release     => 'wheezy',
    repos       => 'main dependencies',
    key         => '47B320EB4C7C375AA9DAE1A01054B7A24BD6EC30',
    key_content => file('ffmff/puppetlabs.asc'),
  }

  class { '::puppetdb::globals':
    version => '2.3.8-1puppetlabs1',
  }

  class { '::puppet':
    puppetmaster                  => 'puppet.ffm.freifunk.net'
    server                        => $master,
    server_foreman                => false,
    server_passenger              => false,
    server_storeconfigs_backend   => 'puppetdb',
    server_directory_environments => true,
    server_git_repo               => true,
    server_puppetdb_host          => 'puppet.ffm.freifunk.net',
    server_external_nodes         => '',
    server_additional_settings    => {
      trusted_node_data => true,
    },
  }

  systemd::service { 'puppet':
    source => 'puppet:///modules/ffmff/systemd/units/puppet.service',
  }

  if $master {
    package { 'ruby-highline':
      ensure => present,
    } ->
    class { '::trocla::config':
      password_length     => 20,
      manage_dependencies => false,
      adapter             => 'YAML',
      adapter_options     => {
        file              => '/var/lib/puppet/server_data/trocla_data.yaml',
      },
    }
    class { '::puppetdb':
      manage_package_repo => false,
    }

    systemd::service { 'puppetmaster':
      source => 'puppet:///modules/ffmff/systemd/units/puppetmaster.service',
    }
  }
}
