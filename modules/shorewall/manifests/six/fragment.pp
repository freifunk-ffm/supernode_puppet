define shorewall::six::fragment (
  $order,
  $content,
  $target,
) {
  validate_integer($order)

  include shorewall::six

  $basedir = $shorewall::six::basedir

  ::concat::fragment { "${basedir}/${target}+${title}":
    target  => "${basedir}/${target}",
    order   => sprintf("%010d", $order),
    content => regsubst(strip(join($content, "	")), '^(.+?)(\t-)*$', '\1'),
  }
}
