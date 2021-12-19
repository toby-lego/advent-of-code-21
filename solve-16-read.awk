func b2n(n, nn, out) {
  split(n, nn, "")
  for(n = 1; n <= length(nn); n++)
    out += 2 ** (length(nn) - n) * nn[n]
  return out
}
BEGIN { delete V; delete T }
length(V) < 3 { V[length(V)] = $1; next }
length(T) < 3 { T[length(T)] = $1; next }
!final {
  #print NR, "Blah", $0
  final = !$1
  for(i = 0; i < 4; i++) {
    getline
    #print NR, "Reading new", $1
    acc = acc $1
  }
  next
}
END { print b2n(acc) }
