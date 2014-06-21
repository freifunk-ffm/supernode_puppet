class fastd_web_service ($fastd_web_service_auth) {
  package { 'ruby-sinatra':
    ensure  => installed,
  }

  package { 'rubygems':
    ensure  => installed,
  }

  package { 'sinatra-contrib':
    ensure    => installed,
    provider  => 'gem',
    require   => [Package['rubygems'], Package['ruby-sinatra']],
  }

  package { 'netaddr':
    ensure    => installed,
    provider  => 'gem',
    require   => Package['rubygems'],
  }

  package { 'libapache2-mod-passenger':
    ensure  => installed,
    require => Package['apache2'],
  }

  user { 'fastd_serv':
    ensure      => present,
    shell       => '/bin/bash',
    home        => '/home/fastd_serv',
    managehome  => true,
  }

  package { 'sudo':
    ensure  => installed,
    require => User['fastd_serv'],
  }

  augeas { 'sudoers':
    context => '/files/etc/sudoers',
    changes => [
      'set spec[user = "fastd_serv"]/user fastd_serv',
      'set spec[user = "fastd_serv"]/host_group/host ALL',
      'set spec[user = "fastd_serv"]/host_group/command ALL',
      'set spec[user = "fastd_serv"]/host_group/command/tag NOPASSWD',
    ],
    require => Package['sudo'],
  }

  exec { 'fastd-service':
    command => '/usr/bin/git clone https://github.com/ff-kbu/fastd-service.git \
/srv/fastd-service',
    creates => '/srv/fastd-service',
    require => [Package['git'], Package['netaddr'], Package['sinatra-contrib'], Service['fastd'], Augeas['sudoers']],
  }

  augeas { 'apache_fastd_service':
    context => '/files/etc/apache2/sites-available/default',
    changes => [
      'set VirtualHost/*[self::directive="DocumentRoot"]/arg "/srv/fastd-service/public"',
    ],
    require => [Package['apache2'], Exec['fastd-service'], Augeas['sudoers']],
  }

  file { '/etc/apache2/sites-enabled/default':
    ensure  => 'link',
    target  => '/etc/apache2/sites-available/default',
    require => Augeas['apache_fastd_service'],
  }

  file { 'fastd_web_service conf':
    ensure  => file,
    require => Exec['fastd-service'],
    mode    => 0644,
    path    => '/srv/fastd-service/conf.yml',
    content => template('fastd_web_service/conf.yml.erb'),
    notify  => Exec['chown fastd-service']
  }

  exec { 'chown fastd-service':
    command     => '/bin/chown -R fastd_serv:fastd_serv /srv/fastd-service/',
    refreshonly => true,
    require     => [File['fastd_web_service conf'], User['fastd_serv']],
  }
}
