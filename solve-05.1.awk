BEGIN { FS = "[-, >]+" }
function see(x, y) { mx = mx > x ? mx : x; my = my > y ? my : y }
{ see($1, $2); see($3, $4) }
$1 < $3 && $2 == $4 { for(i = $1; i <= $3; i++) v[i][$2]++ }
$3 < $1 && $2 == $4 { for(i = $3; i <= $1; i++) v[i][$2]++ }
$2 < $4 && $1 == $3 { for(i = $2; i <= $4; i++) v[$1][i]++ }
$4 < $2 && $1 == $3 { for(i = $4; i <= $2; i++) v[$1][i]++ }
END {
  for(y = 0; y <= my; y++)
    for(x = 0; x <= mx; x++)
      c += v[x][y] > 1
  print c
}