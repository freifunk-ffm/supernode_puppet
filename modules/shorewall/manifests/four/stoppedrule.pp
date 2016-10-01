define shorewall::four::stoppedrule (
  $action,
  $source,
  $dest,
  $proto = '-',
  $dport = '-',
  $sport = '-',
  $order,
) {
  include shorewall::four::stoppedrules

  validate_integer($order)

  shorewall::four::fragment { "stoppedrules:${title}":
    target  => $shorewall::four::stoppedrules::file,
    order   => $order,
    content => [
      $action, $source, $dest, $proto, $dport, $sport,
    ],
  }

}
