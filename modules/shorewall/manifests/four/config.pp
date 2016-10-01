define shorewall::four::config (
  $value,
) {
  include shorewall::four

  $file = "${shorewall::four::basedir}/${shorewall::four::config}"

  augeas { "shorewall:4:${title}":
    incl    => $file,
    context => "/files${file}",
    lens    => 'Shellvars.lns',
    changes => [
      "set ${title} ${value}",
    ],
    require => File[$file],
    notify  => Service[$shorewall::four::service],
  }
}
