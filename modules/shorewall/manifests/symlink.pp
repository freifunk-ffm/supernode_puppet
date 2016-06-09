define shorewall::symlink (
  $file = $title,
  $six_to_four = true,
) {
  include shorewall::four
  include shorewall::six

  $v4 = "${shorewall::four::basedir}/${file}"
  $v6 = "${shorewall::six::basedir}/${file}"

  if $six_to_four {
    $source = $v6
    $target = $v4
    $service = $shorewall::six::service
  } else {
    $source = $v4
    $target = $v6
    $service = $shorewall::four::service
  }

  file { $source:
    ensure  => link,
    target  => $target,
    require => [
      File[$shorewall::four::basedir],
      File[$shorewall::six::basedir],
    ],
  }

  File[$target] ~> Service[$service]
  File[$source] ~> Service[$service]

}
