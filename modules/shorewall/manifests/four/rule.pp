define shorewall::four::rule (
  $section,
  $order,
  $action,
  $source,
  $dest,
  $proto = '-',
  $dport = '-',
  $sport = '-',
  $origdest = '-',
  $rate = '-',
  $user = '-',
  $mark = '-',
  $connlimit = '-',
  $time = '-',
  $headers = '-',
  $switch = '-',
  $helper = '-',
) {
  include shorewall::four::rules

  validate_integer($order, 9999, 0)

  include shorewall::four::rules::sections

  $offset = upcase($section) ? {
    'ALL'         => $shorewall::four::rules::sections::all,
    'ESTABLISHED' => $shorewall::four::rules::sections::established,
    'RELATED'     => $shorewall::four::rules::sections::related,
    'INVALID'     => $shorewall::four::rules::sections::invalid,
    'UNTRACKED'   => $shorewall::four::rules::sections::untracked,
    'NEW'         => $shorewall::four::rules::sections::new,
    default       => fail("Invalid section: ${section}"),
  }

  $r_dport = is_array($dport) ? {
    true  => join($dport, ','),
    false => $dport,
  }

  $r_sport = is_array($sport) ? {
    true  => join($sport, ','),
    false => $sport,
  }

  $r_proto = is_array($proto) ? {
    true  => join($proto, ','),
    false => $proto,
  }

  $r_source = is_array($source) ? {
    true  => join($source, ','),
    false => $source,
  }

  $r_dest = is_array($dest) ? {
    true  => join($dest, ','),
    false => $dest,
  }

  shorewall::four::fragment { "rules:${title}":
    target  => $shorewall::four::rules::file,
    order   => $order + $offset,
    content => [
      $action, $r_source, $r_dest, $r_proto, $r_dport, $r_sport, $origdest, $rate, $user,
      $mark, $connlimit, $time, $headers, $switch, $helper,
    ],
  }

}
