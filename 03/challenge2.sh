#!/bin/bash
#shellcheck disable=SC2086
convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day03-challenge2.txt}
inputFile=${1:-input.txt}
started=$(date +%s)
echo "started: $started" > $LOGFILE

IFS=$'\n' read -d '' -r -a values < $inputFile;

inputLength=${#values[@]}
[ $DEBUG -eq 1 ] && echo "Lines: $inputLength"
echo "Lines: $inputLength" >> $LOGFILE


declare -A alpha
alpha["a"]=1
alpha["b"]=2
alpha["c"]=3
alpha["d"]=4
alpha["e"]=5
alpha["f"]=6
alpha["g"]=7
alpha["h"]=8
alpha["i"]=9
alpha["j"]=10
alpha["k"]=11
alpha["l"]=12
alpha["m"]=13
alpha["n"]=14
alpha["o"]=15
alpha["p"]=16
alpha["q"]=17
alpha["r"]=18
alpha["s"]=19
alpha["t"]=20
alpha["u"]=21
alpha["v"]=22
alpha["w"]=23
alpha["x"]=24
alpha["y"]=25
alpha["z"]=26
alpha["A"]=27
alpha["B"]=28
alpha["C"]=29
alpha["D"]=30
alpha["E"]=31
alpha["F"]=32
alpha["G"]=33
alpha["H"]=34
alpha["I"]=35
alpha["J"]=36
alpha["K"]=37
alpha["L"]=38
alpha["M"]=39
alpha["N"]=40
alpha["O"]=41
alpha["P"]=42
alpha["Q"]=43
alpha["R"]=44
alpha["S"]=45
alpha["T"]=46
alpha["U"]=47
alpha["V"]=48
alpha["W"]=49
alpha["X"]=50
alpha["Y"]=51
alpha["Z"]=52
seen=""

total=0
track=0
for line in "${values[@]}"; do
  [ $DEBUG -eq 1 ] && echo "${#line}: ${line}"
  if [ $track -eq 0 ]; then
    declare -A a
    a["a"]=0
    a["b"]=0
    a["c"]=0
    a["d"]=0
    a["e"]=0
    a["f"]=0
    a["g"]=0
    a["h"]=0
    a["i"]=0
    a["j"]=0
    a["k"]=0
    a["l"]=0
    a["m"]=0
    a["n"]=0
    a["o"]=0
    a["p"]=0
    a["q"]=0
    a["r"]=0
    a["s"]=0
    a["t"]=0
    a["u"]=0
    a["v"]=0
    a["w"]=0
    a["x"]=0
    a["y"]=0
    a["z"]=0
    a["A"]=0
    a["B"]=0
    a["C"]=0
    a["D"]=0
    a["E"]=0
    a["F"]=0
    a["G"]=0
    a["H"]=0
    a["I"]=0
    a["J"]=0
    a["K"]=0
    a["L"]=0
    a["M"]=0
    a["N"]=0
    a["O"]=0
    a["P"]=0
    a["Q"]=0
    a["R"]=0
    a["S"]=0
    a["T"]=0
    a["U"]=0
    a["V"]=0
    a["W"]=0
    a["X"]=0
    a["Y"]=0
    a["Z"]=0
    declare -A b
    b["a"]=0
    b["b"]=0
    b["c"]=0
    b["d"]=0
    b["e"]=0
    b["f"]=0
    b["g"]=0
    b["h"]=0
    b["i"]=0
    b["j"]=0
    b["k"]=0
    b["l"]=0
    b["m"]=0
    b["n"]=0
    b["o"]=0
    b["p"]=0
    b["q"]=0
    b["r"]=0
    b["s"]=0
    b["t"]=0
    b["u"]=0
    b["v"]=0
    b["w"]=0
    b["x"]=0
    b["y"]=0
    b["z"]=0
    b["A"]=0
    b["B"]=0
    b["C"]=0
    b["D"]=0
    b["E"]=0
    b["F"]=0
    b["G"]=0
    b["H"]=0
    b["I"]=0
    b["J"]=0
    b["K"]=0
    b["L"]=0
    b["M"]=0
    b["N"]=0
    b["O"]=0
    b["P"]=0
    b["Q"]=0
    b["R"]=0
    b["S"]=0
    b["T"]=0
    b["U"]=0
    b["V"]=0
    b["W"]=0
    b["X"]=0
    b["Y"]=0
    b["Z"]=0
    declare -A c
    c["a"]=0
    c["b"]=0
    c["c"]=0
    c["d"]=0
    c["e"]=0
    c["f"]=0
    c["g"]=0
    c["h"]=0
    c["i"]=0
    c["j"]=0
    c["k"]=0
    c["l"]=0
    c["m"]=0
    c["n"]=0
    c["o"]=0
    c["p"]=0
    c["q"]=0
    c["r"]=0
    c["s"]=0
    c["t"]=0
    c["u"]=0
    c["v"]=0
    c["w"]=0
    c["x"]=0
    c["y"]=0
    c["z"]=0
    c["A"]=0
    c["B"]=0
    c["C"]=0
    c["D"]=0
    c["E"]=0
    c["F"]=0
    c["G"]=0
    c["H"]=0
    c["I"]=0
    c["J"]=0
    c["K"]=0
    c["L"]=0
    c["M"]=0
    c["N"]=0
    c["O"]=0
    c["P"]=0
    c["Q"]=0
    c["R"]=0
    c["S"]=0
    c["T"]=0
    c["U"]=0
    c["V"]=0
    c["W"]=0
    c["X"]=0
    c["Y"]=0
    c["Z"]=0
  fi
  len=${#line}
  track=$((track + 1))
  if [ $track -eq 1 ]; then
    for (( i=0; i<$len; i++ )); do
      this_char="${line:$i:1}"
      cur=${a[$this_char]}
      a[$this_char]=$((cur + 1))
    done
  fi
  if [ $track -eq 2 ]; then
    for (( i=0; i<$len; i++ )); do
      this_char="${line:$i:1}"
      cur=${b[$this_char]}
      b[$this_char]=$((cur + 1))
    done
  fi
  if [ $track -eq 3 ]; then
    once=0
    for (( i=0; i<$len; i++ )); do
      this_char="${line:$i:1}"
      cur=${c[$this_char]}
      c[$this_char]=$((cur + 1))

      if [[ ${a[$this_char]} -gt 0 ]] && [[ ${b[$this_char]} -gt 0 ]] && [[ $once -eq 0 ]]; then
        seen="$seen $this_char"
        echo "$this_char" >> $LOGFILE
        once=$((once + 1))
      fi
    done


    track=0

    [ $DEBUG -eq 1 ] && printf "%s " "${!a[@]}"
    [ $DEBUG -eq 1 ] && echo
    [ $DEBUG -eq 1 ] && echo "${a[@]}"
    [ $DEBUG -eq 1 ] && echo "${b[@]}"
    [ $DEBUG -eq 1 ] && echo "${c[@]}"
    echo "$line" >> $LOGFILE
    printf "%s " "${!a[@]}" >> $LOGFILE
    echo >> $LOGFILE
    echo "${a[@]}" >> $LOGFILE
    echo "${b[@]}" >> $LOGFILE
    echo "${c[@]}" >> $LOGFILE
    echo >> $LOGFILE
  fi

done



[ $DEBUG -eq 1 ] && echo "$seen"
echo "$seen" >> $LOGFILE
total=0
for letter in $seen; do
  this=${alpha[$letter]}
  total=$((total+this))
done
echo "$total" | tee -a $LOGFILE
now=$(date +%s)
diff=$((now-started))
echo "ended: $now" >> $LOGFILE
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE