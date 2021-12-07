BEGIN { RS = "," }
{ v[$1] += 1 }
END {
  for(d = 0; d < 256; d++)
    v[(d + 7) % 9] += v[d % 9]

  for(i in v)
    c += v[i]
  print c
}
