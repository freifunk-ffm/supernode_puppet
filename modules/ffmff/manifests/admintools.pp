class ffmff::admintools {
  package { [
    'vim', 'iftop', 'htop',
  ]:
    ensure => installed,
  }
}
