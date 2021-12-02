BEGIN { FS = "" }
{ for(i = 1; i <= NF; i++) v[i] += $i }
END {
  for(i = 1; i <= NF; i++) {
    amount = v[i]
    power = NF - i
    values[amount >= NR / 2] += 2 ** power
  }
  print values[0] * values[1]
}
