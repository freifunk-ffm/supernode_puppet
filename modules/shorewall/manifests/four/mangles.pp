class shorewall::four::mangles {
  $file = 'mangle'
  shorewall::four::concat { $file: }
}
