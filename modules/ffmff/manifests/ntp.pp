class ffmff::ntp {
   class { '::ntp':
     servers  => [ '1.ntp.services.ffffm', 'ntp.services.ffffm' ],
     restrict => ['10.126.0.0/24', 'default limited kod nomodify notrap nopeer noquery', '-6 default limited kod nomodify notrap nopeer noquery' ],
     disable_monitor => true,
   }
}

