class shorewall::four::stoppedrules {
  $file = 'stoppedrules'
  shorewall::four::concat { $file: }
}
