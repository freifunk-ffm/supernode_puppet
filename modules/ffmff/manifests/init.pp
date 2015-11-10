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
  include ::ffmff::ntp

  package { [
    'vim', 'iftop'
  ]:
    ensure => installed,
  }
}
