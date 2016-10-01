class shorewall::four::tunnels {
  $file = 'tunnels'
  shorewall::four::concat { $file: }
}
