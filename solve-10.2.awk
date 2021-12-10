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
