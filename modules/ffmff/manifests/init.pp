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
  include ::firewall
  include ::ffmff::ntp
  include ::ffmff::admintools
  include ::ffmff::locales
  include ::ffmff::timezone
}
