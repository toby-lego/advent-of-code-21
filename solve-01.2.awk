{
  values[NR] = $1
  current = values[NR] + values[NR-1] + values[NR-2]
  count += current > previous && NR > 3
  previous = current
  delete values[NR-2]
}
END { print count }
