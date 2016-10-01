class shorewall::six::rules {
  $file = 'rules'
  shorewall::six::concat { $file: }
}
