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
