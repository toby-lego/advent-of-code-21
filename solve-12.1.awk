BEGIN { FS = "-"; delete arr }
{ map[$1][length(map[$1])] = $2; map[$2][length(map[$2])] = $1 }
END { path("start", arr); print(acc) }

func push(visited, v) { visited[length(visited)] = v; return 1 }
func pop(visited) { delete visited[length(visited) - 1] }
func in_(visited, v,  i) { for(i in visited) if(visited[i] == v) return 1; return 0 }

func path(current, visited) {
  push(visited, current)

  for(i in map[current]) {
    option = map[current][i]
    already = in_(visited, option)
    small = option ~ /[a-z]/

    if(small && already)
      continue

    if(option == "end") {
      acc += 1
      continue
    }

    path(option, visited)
  }
  pop(visited)
}
