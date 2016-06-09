define shorewall::four::masq (
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
  include shorewall::four::masqs

  shorewall::four::fragment { "masqs+${title}":
    target  => $shorewall::four::masqs::file,
    order   => $order,
    content => [
      $interface, $source, $address, $proto, $port, $ipsec, $mark, $user,
      $switch, $origdest, $probability,
    ],
  }
