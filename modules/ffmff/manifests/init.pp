class ffmff (
  $puppetmaster = false,
  $disable_firewall = false,
) {
  validate_bool($puppetmaster)

  include ::ffmff::apt
  class { '::ffmff::puppet':
    master => $puppetmaster,
  }
  include ::screen
  include ::rsyslog
  include ::sshd
  include ::postfix

  if !$disable_firewall {
    include ::firewall
  } else {
    file { '/etc/fw/':
      ensure => absent,
      force  => true,
    }
  }
  include ::ffmff::ntp
  include ::ffmff::admintools
  include ::ffmff::locales
  include ::ffmff::timezone
  include prometheus::node_exporter
}
