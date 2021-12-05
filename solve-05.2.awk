BEGIN { FS = "[-, >]+" }
{ xs = ys = 0 }
$1 < $3 { xs =  1 }
$3 < $1 { xs = -1 }
$2 < $4 { ys =  1 }
$4 < $2 { ys = -1 }
{
  v[$1][$2]++
  while($1 != $3 || $2 != $4) {
    $1 += xs
    $2 += ys
    v[$1][$2]++
  }
}
END { for(x in v) for(y in v[x]) c += v[x][y] > 1; print c }
