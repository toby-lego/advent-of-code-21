BEGIN   { FS = " -> " }
NR == 1 {
  split($0, arr, "")
  for(i = 1; i < length(arr); i++)
    input[arr[i] arr[i+1]] += 1
  print
}
NF > 0  { pairs[$1] = $2 }
END {
  for(i in input) printf "%s:%s%s", i, input[i], OFS; print ""
  for(i = 1; i <= 40; i++) {
    iterate(input)
    count(input, output)
    printf "After step %s: ", i

    for(j in output) {
      bonus = j == arr[1] || j == arr[length(arr)] ? 1 : 0
      val = int(output[j] / 2) + bonus
      max = max > val ? max : val
      min = min < val ? min : val
      printf "%s:%s%s", j, val, OFS
    }
    printf "\t%s\n", max - min
    max = 0; min = 1e10
  }
}
function iterate(arr, i, pair, new, new_arr, ab) {
  delete new_arr
  for(pair in arr) {
    split(pair, ab, "")
    new = pairs[pair]
    new_arr[ab[1] new] += arr[pair]
    new_arr[new ab[2]] += arr[pair]
    #print pair, "turned into", ab[1] new, new ab[2]
    delete arr[pair]
  }
  for(i in new_arr) arr[i] = new_arr[i]
}
function new_pairs(a, b, arr, new) {
  new = pairs[a b]
  arr[a new] += 1
  arr[new b] += 1
}
function count(input, output, pair, ab) {
  delete output
  for(pair in input) {
    split(pair, ab, "")
    output[ab[1]] += input[pair]
    output[ab[2]] += input[pair]
  }
}
