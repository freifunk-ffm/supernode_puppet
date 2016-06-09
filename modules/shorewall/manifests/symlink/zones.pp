class shorewall::symlink::zones (
  $six_to_four = undef,
) {
  shorewall::symlink { 'zones':
    six_to_four => $six_to_four,
  }
}
