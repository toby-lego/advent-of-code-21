/up/      { depth -= $2 }
/down/    { depth += $2 }
/forward/ { horizontal += $2 }
END { print horizontal * depth }
