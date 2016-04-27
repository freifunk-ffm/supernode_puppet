class sysctl_conf {
  augeas { '/etc/sysctl.conf':
    context => '/files/etc/sysctl.conf',
    changes => [
      'set net.ipv4.ip_forward 1',
      'set net.ipv4.ip_no_pmtu_disc 1',
      'set net.ipv4.route.flush 1',
      'set net.ipv6.conf.all.forwarding 1',
      'set net.ipv6.conf.all.autoconf 0',
      'set net.ipv6.conf.all.accept_ra 0',
      'set net.core.rmem_max 83886080',
      'set net.core.wmem_max 83886080',
      'set net.core.rmem_default 83886080',
      'set net.core.wmem_default 83886080',
      'set net.ipv4.conf.all.send_redirects 0',
      'set net.ipv4.conf.batbridge.send_redirects 0',
      'set net.ipv6.conf.batbridge.accept_ra 2',
      'set net.ipv4.neigh.default.gc_thresh1 256',
      'set net.ipv4.neigh.default.gc_thresh2 1024',
      'set net.ipv4.neigh.default.gc_thresh3 2048',
      'set net.ipv6.neigh.default.gc_thresh1 256',
      'set net.ipv6.neigh.default.gc_thresh2 1024',
      'set net.ipv6.neigh.default.gc_thresh3 2048',
      'set net.netfilter.nf_conntrack_max 32000',
    ],
  }
}
