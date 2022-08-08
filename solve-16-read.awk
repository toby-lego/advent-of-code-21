BEGIN { delete versions }
func push(ver, n) { ver[length(ver)] = n }
func b2n(n, nn, out) {
  split(n, nn, "")
  for(n = 1; n <= length(nn); n++)
    out += 2 ** (length(nn) - n) * nn[n]
  return out
}
func read(n, acc, i) {
  for(i = 0; i < n; i++) {
    getline
    acc = acc $1
  }
  return acc
}

## in header
length(V) < 3 { V = V $1; next }
length(T) < 3 { T = T $1; next }
# End of magic bits, set up header values
!Type { Ver = b2n(V); Type = b2n(T); Literal = Type == 4; Operator = Type != 4; push(versions, Ver) }
Literal && !final {
  final = !$1
  acc = read(4, acc)
  next
}
Literal && final { print "Finished literal", b2n(acc); V = ""; T = ""; Type = "" }
Operator && I == ""      { I = $1 }
Operator && I == 0 && !L { L = b2n(read(15)); S = 1; next }
Operator && I == 1 && !L { L = b2n(read(11)); S = 1; next }
Operator && S { print "Finished operator", Ver, Type; V = ""; T = ""; Type = "" }
END { print b2n(acc), V, T }
