define shorewall::four::policy (
  $source,
  $dest,
  $policy,
  $order,
  $log_level = '',
  $burst = [],
  $connlimit = [],
) {
  include shorewall::four::policies

  $r_burst = join($burst, ',')
  $r_connlimit = join($connlimit, ',')

  shorewall::four::fragment { "policy:${title}":
    target  => $shorewall::four::policies::file,
    order   => $order,
    content => [
      $source, $dest, $policy, $log_level, $r_burst, $r_connlimit,
    ],
  }
}
