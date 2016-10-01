define shorewall::four::host (
  $host = $title,
  $zone,
  $interface,
  $options = '-',
  $order,
) {
  include shorewall::four::hosts

  $r_host = is_array($host) ? {
    true  => join($host, ','),
    false => $host,
  }

  $r_options = is_array($options) ? {
    true  => join($options, ','),
    false => $options,
  }

  $address = "${interface}:${r_host}"

  shorewall::four::fragment { "hosts:${title}":
    target  => $shorewall::four::hosts::file,
    order   => $order,
    content => [
      $zone, $address, $options,
    ],
  }

}
