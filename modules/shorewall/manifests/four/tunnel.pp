define shorewall::four::tunnel (
  $type,
  $zone,
  $gateway,
  $gateway_zone = '-',
  $order = 1,
) {
  include shorewall::four::tunnels

  $r_gateway = is_array($gateway) ? {
    true  => join($gateway, ','),
    false => $gateway,
  }

  shorewall::four::fragment { "tunnels:${title}":
    target  => $shorewall::four::tunnels::file,
    order   => $order,
    content => [
      $type, $zone, $r_gateway, $gateway_zone,
    ],
  }

}
