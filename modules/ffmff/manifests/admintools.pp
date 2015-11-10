class ffmff::admintools {
  package { [
    'vim', 'iftop', 'htop', 'tmux',
  ]:
    ensure => installed,
  }
}
