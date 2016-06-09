class shorewall::four::masqs {
  $file = 'masq'
  shorewall::four::concat { $file: }
}
