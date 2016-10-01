class shorewall::symlink::stoppedrules (
  $six_to_four = undef,
) {
  shorewall::symlink { 'stoppedrules':
    six_to_four => $six_to_four,
  }
}
