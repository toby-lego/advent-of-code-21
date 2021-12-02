# AOC 2021

The very first challenge was really a very good match for `awk` so I did it with that, now I'm trying to see how far I can get with it 😄

I have been updating my solutions as I discover new tricks in later days, so these aren't necessarily the first attempts.

Run one:
```sh
awk -f solve-0.1.1.awk input-01
```

Run all:
```sh
ls | awk -F "[-.]" '/solve/ { print "awk -f " $0 " input-" $2 }' | bash
```

### Day 1

Part one, very awk friendly.
```awk
BEGIN { last = 1e10 }
{ if(last < $1) count++; last = $1 }
END { print count }
```

Part two, first time using arrays in awk. My first solution was to pull it all into memory and then window in the `END` block, but I think this way is nicer. I'm not actually sure if the memory is really saved by the `delete` but the data set isn't big enough to matter so it works with and without.

```awk
{
  values[NR] = $1
  current = values[NR] + values[NR-1] + values[NR-2]
  count += current > previous && NR > 3
  previous = current
  delete values[NR-2]
}
END { print count }
```

### Day 2

Again the challenges match `awk` well.

```awk
/up/      { depth -= $2 }
/down/    { depth += $2 }
/forward/ { horizontal += $2 }
END { print horizontal * depth }
```
```awk
/up/      { aim -= $2 }
/down/    { aim += $2 }
/forward/ { horizontal += $2; depth += aim * $2 }
END { print horizontal * depth }
```

### Day 3

The `FS = ""` trick to read each character as a field makes this GNU awk specific.

```awk
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
```

This was tough to get the tree to work, manipulating arrays, especially when they may be uninitialised is fiddly, but I'm happy with how it turned out. It also features indirect calling with the `@variable` feature. Unfortunately it doesn't work if you just pass an operator, so I had to declare `mcc` and `lcc`

```awk
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
```

### Day 4

Single script for both parts, not very exciting just standard nested arrays. This was the first time I really got bitten by the global variables in functions problem awk has. I fought a lot trying to find a nice way to defer reading the first of the file until the `END` block but it is much cleaner to just read it at the beginning.

```awk
BEGIN   { FS=" "; board = 0; items = 5 }
/,/     { split($0, inputs, ","); next }
/^$/    { board += 1; row = 0 }
/[0-9]/ { row += 1; for(i = 1; i <= NF; i++) boards[board][row][i] = $i }
END {
  for(idx in inputs) {
    drawn = inputs[idx]
    for(b in boards)
    {
      mark(b, drawn)
      if(!check(b))
        continue
      if(length(boards) == board || length(boards) == 1)
        print b, "=", drawn * sum(b)
      delete boards[b]
    }
  }
}

function print_board(b) {
  for(r = 1; r <= row; r++)
    for(i = 1; i <= items; i++)
      printf "%s%s", boards[b][r][i], i == items ? ORS : OFS
}

function mark(b, n) {
  for(r = 1; r <= row; r++)
    for(i = 1; i <= items; i++)
      if(boards[b][r][i] == n)
        boards[b][r][i] = "X"
}

function check(b) {
  for(r = 1; r <= row; r++) {
    matches_r = 0
    matches_c = 0
    for(i = 1; i <= items; i++) {
      matches_r += boards[b][r][i] == "X"
      matches_c += boards[b][i][r] == "X"
    }
    if(matches_r == 5 || matches_c == 5)
      return 1
  }
}

function sum(b, acc) {
  for(r = 1; r <= row; r++)
    for(i = 1; i <= items; i++)
      if(boards[b][r][i] != "X")
        acc += boards[b][r][i]
  return acc
}
```

### Day 5

A little bit noisy but I still think the guards are a nice way to handle these ones.

```awk
BEGIN { FS = "[-, >]+" }
function see(x, y) { mx = mx > x ? mx : x; my = my > y ? my : y }
{ see($1, $2); see($3, $4) }
$1 < $3 && $2 == $4 { for(i = $1; i <= $3; i++) v[i][$2]++ }
$3 < $1 && $2 == $4 { for(i = $3; i <= $1; i++) v[i][$2]++ }
$2 < $4 && $1 == $3 { for(i = $2; i <= $4; i++) v[$1][i]++ }
$4 < $2 && $1 == $3 { for(i = $4; i <= $2; i++) v[$1][i]++ }
END {
  for(y = 0; y <= my; y++)
    for(x = 0; x <= mx; x++)
      c += v[x][y] > 1
  print c
}
```

```awk
BEGIN { FS = "[-, >]+" }
function see(x, y) { mx = mx > x ? mx : x; my = my > y ? my : y }
{ xs = ys = 0; see($1, $2); see($3, $4) }
$1 < $3 { xs =  1 }
$3 < $1 { xs = -1 }
$2 < $4 { ys =  1 }
$4 < $2 { ys = -1 }
{
  while($1 != $3 || $2 != $4) {
    v[$1][$2]++
    $1 += xs
    $2 += ys
  }
  v[$1][$2]++
}
END {
  for(y = 0; y <= my; y++)
    for(x = 0; x <= mx; x++)
      c += v[x][y] > 1
  print c
}
```