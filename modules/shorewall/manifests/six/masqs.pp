class shorewall::six::masqs {
  $file = 'masq'
  shorewall::six::concat { $file: }
}
