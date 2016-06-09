class shorewall::four::interfaces {
  $file = 'interfaces'
  shorewall::four::concat { $file:
    header => '?FORMAT 2',
  }
}
