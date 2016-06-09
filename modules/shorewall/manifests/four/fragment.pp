define shorewall::four::fragment (
  $order,
  $content,
  $target,
) {
  validate_integer($order)

  include shorewall::four

  $basedir = $shorewall::four::basedir

  ::concat::fragment { "${basedir}/${target}+${title}":
    target  => "${basedir}/${target}",
    order   => sprintf("%010d", $order),
    content => strip(join($content, "	")),
  }
}
