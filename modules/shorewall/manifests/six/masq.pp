define shorewall::six::masq (
  $order,
  $interface,
  $source = '-',
  $address = '-',
  $proto = '-',
  $port = '-',
  $ipsec = '-',
  $mark = '-',
  $user = '-',
  $switch = '-',
  $origdest = '-',
  $probability = '-',
) {
  include shorewall::six::masqs

  shorewall::six::fragment { "masqs+${title}":
    target  => $shorewall::six::masqs::file,
    order   => $order,
    content => [
      $interface, $source, $address, $proto, $port, $ipsec, $mark, $user,
      $switch, $origdest, $probability,
    ],
  }
}
