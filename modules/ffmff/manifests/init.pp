class ffmff (
  $puppetmaster = false,
) {
  validate_bool($puppetmaster)

  include ::ffmff::apt
  class { '::ffmff::puppet':
    master => $puppetmaster,
  }
  include ::rsyslog
  include ::sshd
  include ::postfix
  include ::ffmff::firewall

  package { [
    'ntp', 'vim', 'iftop'
  ]:
    ensure => installed,
  }
}
