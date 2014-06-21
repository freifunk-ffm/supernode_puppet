class tinc (
  $backbone_ip_suffix, 
  $ipv4_subnet_start, 
  $ipv6_subnet, 
  $supernodenum
) {

  package { 'tinc':
    ensure  => installed,
  }
  
  package { 'git':
    ensure  => installed,
  }

  service { 'tinc':
    ensure      => running,
    enable     => true,
    hasrestart  => true,
    hasstatus   => false,
    require     => Package['tinc'],
  }

  file { ['/etc/tinc/', '/etc/tinc/backbone']:
    ensure  => directory,
    notify  => [Exec['tinc_nets_boot'], File['tinc_conf'], File['tinc_up'], Exec['bbkeys']],
    require => Package['tinc'],
  }

  exec { 'tinc_nets_boot':
    command => '/bin/echo "backbone" > /etc/tinc/nets.boot',
    unless  => '/bin/grep backbone /etc/tinc/nets.boot',
  }

  exec { 'bbkeys':
    command => '/usr/bin/git clone https://github.com/ff-kbu/bbkeys \
/etc/tinc/backbone/hosts',
    creates => '/etc/tinc/backbone/hosts',
    notify  => Exec['tinc_gen_key'],
    require => Package['git'],
  }

  exec { 'tinc_gen_key':
    command => '/usr/sbin/tincd -n backbone -K 4096',
    unless  => "/bin/ls /etc/tinc/backbone/ | /bin/grep rsa_key.priv",
    notify  => [Exec['concat_subnet_key'], File['tinc_pub_subnet']],
    require => Package['tinc'],
  }

  file { 'tinc_pub_subnet':
    ensure  => file,
    path    => '/etc/tinc/backbone/subnet',
    content => template('tinc/subnet.erb'),
    notify  => Exec['concat_subnet_key'],
  }

  exec { 'concat_subnet_key':
    command     => "/bin/cat /etc/tinc/backbone/subnet /etc/tinc/backbone/rsa_key.pub \
> /etc/tinc/backbone/hosts/fastd$supernodenum",
    refreshonly => true,
    require     => [Exec['tinc_gen_key'], File['tinc_pub_subnet']],
    creates     => "/etc/tinc/backbone/fastd$supernodenum",
  }

  file { 'tinc_conf':
    ensure  => file,
    path    => '/etc/tinc/backbone/tinc.conf',
    content => template('tinc/tinc.conf.erb'),
    require => Exec['concat_subnet_key'],
    notify  => Service['tinc'],
  }

  file { 'tinc_up':
    ensure  => file,
    mode    => 0744,
    path    => '/etc/tinc/backbone/tinc-up',
    content => template('tinc/tinc-up.erb'),
    notify  => Service['tinc'],
  }
}

