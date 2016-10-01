class shorewall::four::rules::sections {
  $all = 0
  $established = 10000
  $related = 20000
  $invalid = 30000
  $untracked = 40000
  $new = 50000

  shorewall::four::rules::section {
    'all':
      offset => $all;
    'established':
      offset => $established;
    'related':
      offset => $related;
    'invalid':
      offset => $invalid;
    'untracked':
      offset => $untracked;
    'new':
      offset => $new;
  }
}
