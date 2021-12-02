BEGIN { FS = "[-, >]+" }
function see(x, y) { mx = mx > x ? mx : x; my = my > y ? my : y }
{ xs = ys = 0; see($1, $2); see($3, $4) }
$1 < $3 { xs =  1 }
$3 < $1 { xs = -1 }
$2 < $4 { ys =  1 }
$4 < $2 { ys = -1 }
{
  while($1 != $3 || $2 != $4) {
    v[$1][$2]++
    $1 += xs
    $2 += ys
  }
  v[$1][$2]++
}
END {
  for(y = 0; y <= my; y++)
    for(x = 0; x <= mx; x++)
      c += v[x][y] > 1
  print c
}
