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

Again `awk` matches the challenges well.

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

This was tough to get the tree to work, but I'm really happy with the result. It reads each line into a binary trie with the subtotals stored on each node, then when answering it navigates down the tree based on the subtotals and the supplied comparison function. It also features indirect calling with the `@variable` feature. Unfortunately it doesn't work if you just pass an operator, so I had to declare `mcc` and `lcc`

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
  return lshift(res, depth) + choose(tree[res], cmp, depth - 1)
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
$1 < $3 && $2 == $4 { for(i = $1; i <= $3; i++) v[i][$2]++ }
$3 < $1 && $2 == $4 { for(i = $3; i <= $1; i++) v[i][$2]++ }
$2 < $4 && $1 == $3 { for(i = $2; i <= $4; i++) v[$1][i]++ }
$4 < $2 && $1 == $3 { for(i = $4; i <= $2; i++) v[$1][i]++ }
END { for(x in v) for(y in v[x]) c += v[x][y] > 1; print c }
```

```awk
BEGIN { FS = "[-, >]+" }
{ xs = ys = 0 }
$1 < $3 { xs =  1 }
$3 < $1 { xs = -1 }
$2 < $4 { ys =  1 }
$4 < $2 { ys = -1 }
{
  v[$1][$2]++
  while($1 != $3 || $2 != $4) {
    $1 += xs
    $2 += ys
    v[$1][$2]++
  }
}
END { for(x in v) for(y in v[x]) c += v[x][y] > 1; print c }
```

### Day 6

An easy one. One script and you just change the loop condition to switch between part one and two.

```awk
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
```

I later thought of a smaller solution. Instead of shifting every element to the left each day, we can just treat it like a circular array and shift the offset. Then all we have to do is to add the zeros to what will be the sixes each day.

```awk
BEGIN { RS = "," }
{ v[$1] += 1 }
END {
  for(d = 0; d < 256; d++)
    v[(d + 7) % 9] += v[d % 9]

  for(i in v)
    c += v[i]
  print c
}
```

### Day 7

After solving these I of course found out online that they just the median and the mean of the points which can be done a lot easier. This approach was an attempt to be more efficient than the brute force solution, by recalculating with each number added and only stepping in the direction it could possibly be moving with the new data to limit the work done. It gives the correct solution and when I put counters inside the loop in the cost function I can see it is significantly less comparisons than a brute force attempt on the whole problem space would require.

```awk
func abs(n) { return n < 0 ? -n : n }
func cost(n, acc) { for(i in v) acc += v[i] * abs(i - n); return acc }
BEGIN { RS = "," }
NR == 1 { position = $1 }
{
  v[$1] += 1;
  fuel += abs($1 - position)
  step = $1 > position ? 1 : -1
  while(1) {
    new_position = position + step
    new_fuel = cost(new_position)
    if(new_fuel >= fuel) break
    position = new_position
    fuel = new_fuel
  }
}
END { print fuel }
```

```awk
func abs(n) { return n < 0 ? -n : n }
func cost(p, acc, n) {
  for(i in v) {
    n = abs(i - p)
    acc += v[i] * n * (n + 1) / 2
  }
  return acc
}
BEGIN { RS = "," }
NR == 1 { position = $1 }
{
  v[$1] += 1;
  n = abs($1 - position)
  fuel += $1 * n * (n - 1) / 2
  step = $1 > position ? 1 : -1
  while(1) {
    new_position = position + step
    new_fuel = cost(new_position)
    if(new_fuel >= fuel) break
    position = new_position
    fuel = new_fuel
  }
}
END { print fuel }
```

### Day 8

Part one was pretty easy, again using the fact that booleans and 0 and 1 to have `accumulator += conditional`.

```awk
BEGIN { m[2] = m[3] = m[4] = m[7] = 1 }
{
  output = 0
  for(i = 1; i <= NF; i++) {
    output += $i == "|"
    acc += output && length($i) in m
  }
}
END { print acc }
```

This was straightforward but a lot of code. I was expecting it to be a harder problem with some of the rows not including all the numbers so you'd have to find multiple ways of deriving the common digits, but luckily this was enough.

```awk
func sort(str, a, i) { split(str, a, ""); asort(a); str = ""; for(i = 1; i <= length(a); i++) str = str a[i]; return str }
func subtract(from, values, arr, i) { split(values, arr, ""); for(i in arr) sub(arr[i], "", from); return from }
func is_subset(from, values, s, l) { s = subtract(from, values); return length(from) - length(values) == length(s) ? s : 0; }
{
  delete digits
  delete fives
  delete sixes

  for(i = 1; i <= NF; i++) {
    if($i == "|") continue
    value = sort($i)
    len = length($i)
    if(len == 2) digits[1] = value
    if(len == 3) digits[7] = value
    if(len == 4) digits[4] = value
    if(len == 5) fives[length(fives)] = value
    if(len == 6) sixes[length(sixes)] = value
    if(len == 7) digits[8] = value
  }

  for(i in sixes) {
    if(is_subset(sixes[i], digits[4]))
      digits[9] = sixes[i]
    else if(is_subset(sixes[i], digits[1]))
      digits[0] = sixes[i]
    else
      digits[6] = sixes[i]
  }

  for(i in fives) {
    if(is_subset(fives[i], digits[1]))
      digits[3] = fives[i]
    else if(is_subset(digits[6], fives[i]))
      digits[5] = fives[i]
    else
      digits[2] = fives[i]
  }

  # invert mapping
  for(i = 0; i <= 9; i++) {
    digits[digits[i]] = i
    delete digits[i]
  }

  i = 1
  delete outputs
  while($i != "|") { i += 1 }
  for(j = i; j <= NF; j++) {
    outputs[j - i] = $j
  }

  output = ""
  for(i in outputs) {
    output = output digits[sort(outputs[i])]
  }
  acc += output
}
END { print acc }
```

### Day 9

One script for both parts today. I wouldn't have thought this would be the best language for writing graph traversals but it turned out to be pretty easy. Push and popi are really not duals in this one but I couldn't find better names.

```awk
BEGIN { FS = "" }
{ for(i = 1; i <= NF; i++) v[NR][i] = $i }
END {
  for(row = 1; row <= NR; row++)
    for(col = 1; col <= NF; col++) {
      adjacent(row, col, adj)

      h = 0
      for(i in adj) {
        h += adj[i] <= v[row][col]
      }
      if(!h) {
        low[row "," col] = v[row][col]
      }
    }
 
  for(i in low)
    acc += low[i] + 1
  print acc

  for(i in low)
    solution[i] = search(i)
  asort(solution)
  l = length(solution)
  print solution[l] * solution[l - 1] * solution[l - 2]
}
func push(arr, row, col) {
  if(row < 1 || col < 1 || row > NR || col > NF) return
  arr[row "," col] = v[row][col]
}
func adjacent(row, col, arr) { 
  delete arr
  push(arr, row - 1, col    )
  push(arr, row,     col - 1)
  push(arr, row,     col + 1)
  push(arr, row + 1, col    )
}
func popi(queue, i, v) { for(i in queue) { v=i; break } delete queue[i]; return v }
func search(start, queue, visited, options, i) {
  queue[start] = 1

  do {
    start = popi(queue)
    split(start, coords, ",")
    adjacent(coords[1], coords[2], options)

    for(i in options)
      if(!(i in visited) && options[i] != "9")
        queue[i] = 1

    visited[start] = 1
  } while (length(queue))

  return length(visited)
}
```

### Day 10

My syntax highlighting couldn't handle the declarations on this one properly but I was happy the queue method in the first method translated so well to the second part.

```awk
BEGIN {
  FS = ""
  s[")"] = 3; s["]"] = 57; s["}"] = 1197; s[">"] = 25137
  o["("] = ")"; o["{"] = "}"; o["["] = "]"; o["<"] = ">"
}
func push(arr, v) { arr[length(arr)] = v; }
func pop(arr, v)  { v = arr[length(arr) - 1]; delete arr[length(arr) - 1]; return v }
{
  delete arr
  for(i = 1; i <= NF; i++)
    if($i in o)
      push(arr, $i)
    else {
      v = pop(arr)
      if($i != o[v]) {
        acc += s[$i]
        next
      }
    }
}
END { print acc }
```

```awk
BEGIN {
  FS = ""
  s[")"] = 1; s["]"] = 2; s["}"] = 3; s[">"] = 4
  o["("] = ")"; o["{"] = "}"; o["["] = "]"; o["<"] = ">"
}
func push(arr, v) { arr[length(arr)] = v; }
func pop(arr, v)  { v = arr[length(arr) - 1]; delete arr[length(arr) - 1]; return v }
{
  delete arr

  for(i = 1; i <= NF; i++)
    if($i in o)
      push(arr, $i)
    else {
      v = pop(arr)
      if($i != o[v]) next
    }

  acc = 0
  while(length(arr))
    acc = (acc * 5) + s[o[pop(arr)]]

  scores[NR] = acc
}
END {
  asort(scores)
  print scores[(length(scores) + 1) / 2]
}
```
