class ffmff::admintools {
  package { [
    'vim', 'iftop', 'htop', 'tmux', 'tcpdump',
  ]:
    ensure => installed,
  }
}
