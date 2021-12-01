{ values[idx++] = $1 }
END {
  last = 1e10
  for(i = 0; i < idx - 2; i++) {
    this = values[i] + values[i+1] + values[i+2]
    if(this > last) count++
    last = this
  }
  print count
}
