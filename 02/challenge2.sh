#!/bin/bash
#shellcheck disable=SC2086
convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day02-challenge2.txt}
inputFile=${1:-input.txt}
started=$(date +%s)
echo "started: $started" > $LOGFILE

# Perserve empty lines
IFS=$'\n' read -d '' -r -a values < $inputFile;

inputLength=${#values[@]}
[ $DEBUG -eq 1 ] && echo "Lines: $inputLength"
echo "Lines: $inputLength" >> $LOGFILE

# A Y -> 1 Rock     draw (1 + 3) -> 4
# B X -> 2 Papper   lose (1 + 0) -> 1
# C Z -> 3 Scissors win  (1 + 6) -> 7


# A X -> (3 + 0) -> 3
# B X -> (1 + 0) -> 1
# C X -> (2 + 0) -> 2
# A Y -> (1 + 3) -> 4
# B Y -> (2 + 3) -> 5
# C Y -> (3 + 3) -> 6
# A Z -> (2 + 6) -> 8
# B Z -> (3 + 6) -> 9
# C Z -> (1 + 6) -> 7

declare -A map
map["A X"]=3
map["B X"]=1
map["C X"]=2
map["A Y"]=4
map["B Y"]=5
map["C Y"]=6
map["A Z"]=8
map["B Z"]=9
map["C Z"]=7

total=0
for line in "${values[@]}"; do
    [ $DEBUG -eq 1 ] && echo "$line"
    this="${map[$line]}"
    total=$((total+this))
done
echo "$total" | tee -a $LOGFILE

now=$(date +%s)
diff=$((now-started))
echo "ended: $now" >> $LOGFILE
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE