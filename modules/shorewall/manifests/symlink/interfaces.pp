class shorewall::symlink::interfaces (
  $six_to_four = undef,
) {
  shorewall::symlink { 'interfaces':
    six_to_four => $six_to_four,
  }
}
