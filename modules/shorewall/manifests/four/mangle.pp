define shorewall::four::mangle (
  $order,
  $action,
  $source,
  $dest = '-',
  $proto = '-',
  $dport = '-',
  $sport = '-',
  $user = '-',
  $test = '-',
  $tos = '-',
  $connbytes = '-',
  $helper = '-',
  $probability = '-',
  $dscp = '-',
  $state = '-',
  $time = '-',
) {
  include shorewall::four::mangles

  shorewall::four::fragment { "mangles+${title}":
    target  => $shorewall::four::mangles::file,
    order   => $order,
    content => [
      $action, $source, $dest, $proto, $dport, $sport, $user, $test, $tos,
      $connbytes, $helper, $probability, $dscp, $state, $time,
    ],
  }
}
