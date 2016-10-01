class shorewall::four::policies {
  $file = 'policy'
  shorewall::four::concat { $file: }
}
