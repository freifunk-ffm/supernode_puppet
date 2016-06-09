class shorewall::four::rules {
  $file = 'rules'
  shorewall::four::concat { $file: }
}
