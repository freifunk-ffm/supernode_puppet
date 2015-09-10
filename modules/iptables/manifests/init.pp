class iptables{
  file { '/etc/iptables/':
    ensure  => directory,
  }

  file { 'iptables.rules':
    path    => '/etc/iptables/iptables.rules',
    owner   => root,
    group   => root,
    source  => 'puppet:///modules/iptables/iptables.rules',
    require => File['/etc/iptables/'],
    notify  => Exec['iptables reload'],
  }

  exec { 'iptables reload':
    command     => '/sbin/iptables-restore /etc/iptables/iptables.rules',
    require     => File['iptables.rules'],
    refreshonly => true,
  }
}
