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
