define shorewall::four::interface (
  $interface = $title,
  $zone,
  $port = undef,
  $broadcast = '-',
  $options = [],
  $order = 1, # dummy order
) {
  validate_string($interface, $zone, $port, $broadcast)
  validate_array($options)

  include shorewall::four::interfaces

  if $port != undef {
    $if_port = "${interface}:${port}"
  } else {
    $if_port = $interface
  }

  $s_options = join($options, ',')

  shorewall::four::fragment { "interfaces:{$title}":
    target  => $shorewall::four::interfaces::file,
    order   => $order,
    content => [
      $zone, $if_port, $broadcast, $s_options,
    ],
  }
}
