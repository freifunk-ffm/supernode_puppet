class ffmff::admintools {
  package { [
    'vim', 'iftop'
  ]:
    ensure => installed,
  }
}
