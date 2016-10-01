class shorewall::symlink::policy (
  $six_to_four = undef,
) {
  shorewall::symlink { 'policy':
    six_to_four => $six_to_four,
  }
}
