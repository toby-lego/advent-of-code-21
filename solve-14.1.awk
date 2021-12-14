BEGIN   { FS = " -> " }
NR == 1 { input = $0; next }
NF > 0  { pairs[$1] = $2 }
END {
  for(j = 1; j <= 40; j++) {
    input = iterate(input)
    counts(input, acc)

    printf "%s:\t", j
    for(k in acc)
      printf "%s: %s\t", k, acc[k]
    print ""
  }

  min = 1e10
  max = 0
  for(i in acc) {
    min = acc[i] < min ? acc[i] : min
    max = acc[i] > max ? acc[i] : max
  }
  print max, "-", min, "=", max - min
}
function iterate(input, i) {
  split(input, formula, "")
  input = ""
  for(i = 1; i < length(formula); i++) {
    pair = formula[i] formula[i+1]
    input = input formula[i] pairs[pair]
  }
  return input formula[length(formula)]
}
function counts(input, acc, formula, i) {
  delete acc
  split(input, formula, "")
  for(i in formula)
    acc[formula[i]] += 1
}
