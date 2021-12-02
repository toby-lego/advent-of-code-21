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
