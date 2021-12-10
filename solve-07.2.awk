func abs(n) { return n < 0 ? -n : n }
func cost(p, acc, n) {
  for(i in v) {
    n = abs(i - p)
    acc += v[i] * n * (n + 1) / 2
  }
  return acc
}
BEGIN { RS = "," }
NR == 1 { position = $1 }
{
  v[$1] += 1;
  n = abs($1 - position)
  fuel += $1 * n * (n - 1) / 2
  step = $1 > position ? 1 : -1
  while(1) {
    new_position = position + step
    new_fuel = cost(new_position)
    if(new_fuel >= fuel) break
    position = new_position
    fuel = new_fuel
  }
}
END { print fuel }
