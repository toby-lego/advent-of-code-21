BEGIN { RS = "," }
{ v[$1] += 1 }
END {
  for(d = 1; d <= 256; d++) {
    zero = v[0]
    for(i = 0; i < 8; i++) v[i] = v[i+1]
    v[6] += zero
    v[8]  = zero
  }

  for(i in v)
    count += v[i]
  print count
}
