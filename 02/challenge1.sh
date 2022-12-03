#!/bin/bash
#shellcheck disable=SC2086
convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day02-challenge1.txt}
inputFile=${1:-input.txt}
started=$(date +%s)
echo "started: $started" > $LOGFILE

# Perserve empty lines
IFS=$'\n' read -d '' -r -a values < $inputFile;

inputLength=${#values[@]}
[ $DEBUG -eq 1 ] && echo "Lines: $inputLength"
echo "Lines: $inputLength" >> $LOGFILE

# A Y -> 1 Rock     (2 + 6) -> 8
# B X -> 2 Papper   (1 + 0) -> 1
# C Z -> 3 Scissors (3 + 3) -> 6

# A X -> (1 + 3) -> 4
# B X -> (1 + 0) -> 1
# C X -> (1 + 6) -> 7
# A Y -> (2 + 6) -> 8
# B Y -> (2 + 3) -> 5
# C Y -> (2 + 0) -> 2
# A Z -> (3 + 0) -> 3
# B Z -> (3 + 6) -> 9
# C Z -> (3 + 3) -> 6

if ! declare -A map 2> /dev/null; then
  echo "Associative arrays not supported with this version of bash! Upgrade bash, or use the container provided."
  /bin/bash --version | head -1
  exit
fi
map["A X"]=4
map["B X"]=1
map["C X"]=7
map["A Y"]=8
map["B Y"]=5
map["C Y"]=2
map["A Z"]=3
map["B Z"]=9
map["C Z"]=6

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