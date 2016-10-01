class shorewall::four::hosts {
  $file = 'hosts'
  shorewall::four::concat { $file: }
}
