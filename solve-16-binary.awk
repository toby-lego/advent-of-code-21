func h2b(d, b, out, i) {while(d){b=d%2 b; d=int(d/2)}; for(i=0;i<4-length(b);i++) out=out "0"; out=out b; return out}
BEGIN { FS = "" }
{
  for(i = 1; i <= NF; i++) {
    val = h2b(strtonum("0x" $i))
    split(val, bits, "")
    for(b = 1; b <= length(bits); b++)
      print bits[b]
  }
}
