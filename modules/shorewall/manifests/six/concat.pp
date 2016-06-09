define shorewall::six::concat (
  $filename = $title,
  $header = undef,
) {
  include shorewall::six

  $basedir = $shorewall::six::basedir
  $package = $shorewall::six::package
  $service = $shorewall::six::service
  $file = "${basedir}/${filename}"

  ::concat { $file:
    ensure         => present,
    ensure_newline => true,
    force          => true,
    owner          => 'root',
    group          => 'root',
    mode           => '0640',
    require        => Package[$package],
    notify         => Service[$service],
  }

  if $header != undef {
    ::concat::fragment { "${file}+${header}":
      target  => $file,
      order   => '000',
      content => "${header}\n\n",
    }
  }
}
