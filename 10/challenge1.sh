#!/bin/bash
#shellcheck disable=SC2086,SC2143
convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day10-challenge1.txt}
inputFile=${1:-input.txt}
started=$(date +%s)
echo "started: $started" > $LOGFILE

IFS=$'\n' read -d '' -r -a values < $inputFile;

inputLength=${#values[@]}
[ $DEBUG -eq 1 ] && echo "Lines: $inputLength"
echo "Lines: $inputLength" >> $LOGFILE

track=0
taction=0
x=1
interesting="20 60 100 140 180 220"
signals=""
for line in "${values[@]}"; do
  strength=0
  track=$((track+1))
  # [ $DEBUG -eq 1 ] && echo "$line"
  actions=$(echo "$line" | tr ' ' '\n' | wc -l | awk '{print $1}')
  taction=$((taction+actions))
  ltaction=$((taction-1))
  if [[ "$line" =~ ^noop$ ]]; then
    echo "${track}[${taction}]: $line" >> $LOGFILE
    echo "x: $x" >> $LOGFILE
    [ $DEBUG -eq 1 ] && echo "${track}[${taction}]: $line" && echo "x: $x"
    if [ -n "$(echo "$interesting" | tr ' ' '\n' | grep -E "^$taction$")" ]; then
      strength=$((taction*x))
      signals="$signals $strength"
      echo "STRENGTH[0][$taction * $x]: $strength" >> $LOGFILE
      [ $DEBUG -eq 1 ] && echo "STRENGTH[0][$taction * $x]: $strength"
    fi
    continue
  fi
  echo "${track}[${ltaction}]: addx" >> $LOGFILE
  echo "x: $x" >> $LOGFILE

  [ $DEBUG -eq 1 ] && echo "${track}[${ltaction}]: addx" && echo "x: $x"

  if [ -n "$(echo "$interesting" | tr ' ' '\n' | grep -E "^$ltaction$")" ]; then
    strength=$((ltaction*x))
    signals="$signals $strength"
    echo "STRENGTH[1][$ltaction * $x]: $strength" >> $LOGFILE
    [ $DEBUG -eq 1 ] && echo "STRENGTH[1][$ltaction * $x]: $strength"
  fi

  val=$(echo "$line" | awk '{print $2}')
  lx=$x
  x=$((x+val))
  echo "${track}[${taction}]: $val" >> $LOGFILE
  echo "x: $x" >> $LOGFILE
  [ $DEBUG -eq 1 ] && echo "${track}[${taction}]: $val" && echo "x: $x"
  if [ -n "$(echo "$interesting" | tr ' ' '\n' | grep -E "^$taction$")" ]; then
    strength=$((taction*lx))
    signals="$signals $strength"
    echo "STRENGTH[2][$taction * $lx]: $strength" >> $LOGFILE
    [ $DEBUG -eq 1 ] && echo "STRENGTH[2][$taction * $lx]: $strength"
  fi
done
echo >> $LOGFILE
strength=$(echo "$signals" | tr ' ' '\n' | awk '{ sum += $1 } END { print sum }')
echo "$strength" | tee -a $LOGFILE

now=$(date +%s)
diff=$((now-started))
echo "ended: $now" >> $LOGFILE
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE