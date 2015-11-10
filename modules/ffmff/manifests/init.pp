class ffmff {
  include ::ffmff::apt
  include ::ffmff::puppet
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
