BEGIN     { FS = "," }
/^$/      { FS = " |="; next }
FS == "," {
  map[$2][$1] = 1;
  width = width > $1 ? width : $1
  height = height > $2 ? height : $2
}
/fold/ {
  y = $3 == "y" ? $4 : 0
  x = $3 == "x" ? $4 : 0

  for(row = 0; row <= height; row++) {
    if(row < y || !(row in map))
      continue

    for(i in map[row]) {
      j = int(i)
      if(j < x)
        continue

      if(y)
        map[y * 2 - row][j] += map[row][j]
      else
        map[row][x * 2 - j] += map[row][j]
      delete map[row][i]
    }
  }
  height = y ? y : height
  width = x ? x : width
  print count()
}
END { 
  for(i = 0; i <= height; i++)
    for(j = 0; j <= width; j++)
      printf "%s%s", i in map && j in map[i] ? "#" : ".", j == width ? ORS : OFS
}
func count(acc) { for(i in map) acc += length(map[i]); return acc }
