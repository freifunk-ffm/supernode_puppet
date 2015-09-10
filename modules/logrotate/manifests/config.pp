define logrotate::config (
  $source = undef,
  $content = undef,
) {
  include ::logrotate

  $target = "/etc/logrotate.d/${title}"

  file { $target:
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => $source,
    content => $content,
    require => Class['::logrotate'],
  }
}
