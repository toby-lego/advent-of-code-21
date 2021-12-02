function add_values(tree, values, i) {
  if(i in values) {
    current = values[i]
    tree[current][2]++
    add_values(tree[current], values, i + 1)
  }
}
function choose(tree, cmp, depth) {
  z = tree[0][2] 
  o = tree[1][2]
  if(!z && !o) return
  res = (z && !o) ? 0 : (!z && o) || @cmp(z, o)
  return res * (2 ** depth) + choose(tree[res], cmp, depth - 1)
}
function mcc(zeros, ones) { return ones >= zeros }
function lcc(zeros, ones) { return ones < zeros  }
BEGIN { FS = "" }
{
  split($0, vals);
  add_values(tree, vals, 1)
}
END {
  oxygen = choose(tree, "mcc", NF - 1)
  co2 = choose(tree, "lcc", NF - 1)
  print oxygen * co2
}
