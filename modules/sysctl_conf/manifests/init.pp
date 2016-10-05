class sysctl_conf {
	file { '/etc/sysctl.conf':
		ensure  => file,
		owner   => 'root',
		group   => 'root',
		mode    => '0644',
		content => template('sysctl_conf/sysctl.conf.erb'),
		notify  => [
			Exec["sysctl"],
		],
	}

	exec { "sysctl":
		command     => "sysctl -p /etc/sysctl.conf",
		path        => [ '/usr/sbin', '/sbin', '/usr/bin', '/bin' ],
		refreshonly => true,
		require     => File["/etc/sysctl.conf"],
	}
}
