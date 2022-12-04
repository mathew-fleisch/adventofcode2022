#!/bin/bash
#shellcheck disable=SC2086
convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day04-challenge1.txt}
inputFile=${1:-input.txt}
started=$(date +%s)
echo "started: $started" > $LOGFILE

IFS=$'\n' read -d '' -r -a values < $inputFile;

inputLength=${#values[@]}
[ $DEBUG -eq 1 ] && echo "Lines: $inputLength"
echo "Lines: $inputLength" >> $LOGFILE

if ! declare -A map 2> /dev/null ; then
  echo "Associative arrays not supported with this version of bash! Upgrade bash, or use the container provided."
  /bin/bash --version | head -1
  exit
fi

total=0
for line in "${values[@]}"; do
  [ $DEBUG -eq 1 ] && echo "$line"
  elf1=$(echo "$line" | awk -F',' '{print $1}')
  elf1low=$(echo "$elf1" | awk -F'-' '{print $1}')
  elf1high=$(echo "$elf1" | awk -F'-' '{print $2}')
  elf2=$(echo "$line" | awk -F',' '{print $2}')
  elf2low=$(echo "$elf2" | awk -F'-' '{print $1}')
  elf2high=$(echo "$elf2" | awk -F'-' '{print $2}')
  [ $DEBUG -eq 1 ] && echo "Elf1: $elf1 -> $elf1low - $elf1high"
  [ $DEBUG -eq 1 ] && echo "Elf2: $elf2 -> $elf2low - $elf2high"
  if [[ $elf1low -ge $elf2low ]] && [[ $elf1high -le $elf2high ]]; then
    total=$((total+1))
  elif [[ $elf2low -ge $elf1low ]] && [[ $elf2high -le $elf1high ]]; then
    total=$((total+1))
  fi
done
echo >> $LOGFILE
echo "$total" | tee -a $LOGFILE

now=$(date +%s)
diff=$((now-started))
echo "ended: $now" >> $LOGFILE
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE