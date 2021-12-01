BEGIN { last = "1e10" }
{ if(last < $1) count++; last = $1 }
END { print count }
