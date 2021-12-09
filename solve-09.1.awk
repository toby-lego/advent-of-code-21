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
}
func push(arr, row, col) {
  if(row < 1 || col < 1 || row > NR || col > NF) return
  arr[length(arr)] = v[row][col]
}
func adjacent(row, col, arr) { 
  delete arr
  push(arr, row - 1, col    )
  push(arr, row,     col - 1)
  push(arr, row,     col + 1)
  push(arr, row + 1, col    )
}
