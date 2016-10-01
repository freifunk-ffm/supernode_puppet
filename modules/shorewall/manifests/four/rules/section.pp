define shorewall::four::rules::section (
  $offset,
) {
  validate_integer($offset)

  include shorewall::four::rules

  $s_section = upcase($title)

  shorewall::four::fragment { "rules:section:${s_section}":
    target  => $shorewall::four::rules::file,
    order   => $offset,
    content => ["?SECTION ${s_section}"],
  }
}
