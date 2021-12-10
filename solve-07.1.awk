func abs(n) { return n < 0 ? -n : n }
func cost(n, acc) { for(i in v) acc += v[i] * abs(i - n); return acc }
BEGIN { RS = "," }
NR == 1 { position = $1 }
{
  v[$1] += 1;
  fuel += abs($1 - position)
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
