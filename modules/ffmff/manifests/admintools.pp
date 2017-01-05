class ffmff::admintools {
  package { [
    'vim', 'iftop', 'htop', 'tmux', 'tcpdump', 'iputils-tracepath',
  ]:
    ensure => installed,
  }
}
