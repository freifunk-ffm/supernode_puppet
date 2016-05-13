# test123 

node /fastd\d+\.ffm\.freifunk\.net/ {
  $certname = $::trusted['certname']

  $supernodenum = regsubst($certname,'^fastd(\d+).*','\1')
  $fastd_key = trocla_get("fastd/${certname}/key")

  class { 'ffmff::supernode':
    supernodenum => $supernodenum,
    fastd_key    => $fastd_key,
    rndmac       => fqdn_rand(99),
  }
}

node /lxc\d+\.ffm.freifunk.net/ {
  $lxcnum = regsubst($certname,'^lxc(\d+).*','\1')
  class { 'ffmff::lxc':
	lxcnum => $lxcnum,
	rndmac => fqdn_rand(99),
}

node 'mail.ffm.freifunk.net' {
  class { 'mailserver': }
}

node 'puppet.ffm.freifunk.net' {
  class { 'ffmff':
    puppetmaster => true,
  }
}

node 'fastd25.ffm.freifunk.net' {
  class { 'ffmff::supernode':
    supernodenum => 20,  # maximum...
    fastd_key    => '0000000000000000000000000000000000000000000000000000000000000000',
    rndmac       => fqdn_rand(99),
  }
}
