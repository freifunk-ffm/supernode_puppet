node /fastd\d+\.ffm\.freifunk\.net/ {
  $certname = $trusted['certname']

  $supernodenum = regsubst($certname,'^fastd(\d+).*','\1')
  $fastd_key = trocla_get("fastd/${certname}/key")

  class { 'ffmff::supernode':
    supernodenum => $supernodenum,
    fastd_key    => $fastd_key,
    rndmac       => fqdn_rand(99),
  }
}
