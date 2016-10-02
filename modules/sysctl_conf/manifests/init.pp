class sysctl_conf {
#	package { 'sysctl':
#		ensure => installed,
#	}
#	service { 'sysctl':
#		ensure  => running,
#		require => Package['sysctl'],
#	}
	File {
		owner => 'root',
		group => 'root',
	}
	file { '/etc/sysctl.conf':
		ensure  => file,
		content => template('sysctl_conf/sysctl.conf.erb'),
		mode    => '0644',
#		require => Package['sysctl'],
		notify  => Service['sysctl'],
	}
}
