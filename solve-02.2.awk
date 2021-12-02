/up/      { aim -= $2 }
/down/    { aim += $2 }
/forward/ { horizontal += $2; depth += aim * $2 }
END { print horizontal * depth }
