class ffmff::ntp {
   class { '::ntp':
     servers  => [ '1.ntp.services.ffffm', 'ntp.services.ffffm' ],
     restrict => ['10.126.0.0/24'],
   }
}
