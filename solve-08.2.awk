# 2 chars: 1
# 3 chars: 7
# 4 chars: 4
# 5 chars: 2, 3, 5
# 6 chars: 0, 6, 9
# 8 chars: 8
#
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
