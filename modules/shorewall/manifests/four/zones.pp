class shorewall::four::zones {
  $file = 'zones'
  shorewall::four::concat { $file: }
}
