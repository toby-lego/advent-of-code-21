BEGIN { m[2] = m[3] = m[4] = m[7] = 1 }
{
  output = 0
  for(i = 1; i <= NF; i++) {
    output += $i == "|"
    acc += output && length($i) in m
  }
}
END { print acc }
