class ffmff {
  include ::ffmff::apt
  include ::puppet
  include ::rsyslog
  include ::sshd
  include ::postfix
  include ::firewall

  package { [
    'ntp', 'vim',
  ]:
    ensure => installed,
  }
}
