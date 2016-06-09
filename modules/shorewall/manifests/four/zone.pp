define shorewall::four::zone (
  # FIXME: parent zones
  $order = 1, # dummy order
  $type = '',
) {
  include shorewall::four::zones

  shorewall::four::fragment { "zone:$title":
    target  => $shorewall::four::zones::file,
    order   => $order,
    content => [
      $title, $type,
    ],
  }
}
