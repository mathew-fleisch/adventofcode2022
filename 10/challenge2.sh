#!/bin/bash
#shellcheck disable=SC2086,SC2143,SC2003,SC2046
convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day10-challenge2.txt}
inputFile=${1:-input.txt}
started=$(date +%s)
echo "started: $started" > $LOGFILE

IFS=$'\n' read -d '' -r -a values < $inputFile;

inputLength=${#values[@]}
[ $DEBUG -eq 1 ] && echo "Lines: $inputLength"
echo "Lines: $inputLength" >> $LOGFILE

track=0
taction=0
horizontal=0
x=1
lx=1
# interesting="20 60 100 140 180 220"
stage=""
for line in "${values[@]}"; do
  track=$((track+1))
  # [ $DEBUG -eq 1 ] && echo "$line"
  actions=$(echo "$line" | tr ' ' '\n' | wc -l | awk '{print $1}')
  taction=$((taction+actions))
  ltaction=$((taction-1))
  if [[ "$line" =~ ^noop$ ]]; then
    echo "${track}[${taction}]: $line" >> $LOGFILE
    echo "x: $x" >> $LOGFILE
    horizontal=$(expr $taction % 40)
    horizontal=$((horizontal-1))
    [ $DEBUG -eq 1 ] && echo "${track}[${taction}][$horizontal][0]: x: $x"
    x1=$((x-1))
    x2=$((x+1))
    if [ $horizontal -eq $x1 ] || [ $horizontal -eq $x ] || [ $horizontal -eq $x2 ]; then
      stage="${stage}#"
    else
      stage="${stage} "
    fi
    continue
  fi
  echo "${track}[${ltaction}]: addx" >> $LOGFILE
  echo "x: $x" >> $LOGFILE
  horizontal=$(expr $ltaction % 40)
  horizontal=$((horizontal-1))
  [ $DEBUG -eq 1 ] && echo "${track}[${ltaction}][$horizontal][1]: x: $x"
  x1=$((x-1))
  x2=$((x+1))
  if [ $horizontal -eq $x1 ] || [ $horizontal -eq $x ] || [ $horizontal -eq $x2 ]; then
    stage="${stage}#"
  else
    stage="${stage} "
  fi
  
  val=$(echo "$line" | awk '{print $2}')
  lx=$x
  x=$((x+val))
  echo "${track}[${taction}]: $val" >> $LOGFILE
  echo "x: $x" >> $LOGFILE
  horizontal=$(expr $taction % 40)
  horizontal=$((horizontal-1))
  [ $DEBUG -eq 1 ] && echo "${track}[${taction}][$horizontal][2]: x: $lx"
  x1=$((lx-1))
  x2=$((lx+1))
  if [ $horizontal -eq $x1 ] || [ $horizontal -eq $lx ] || [ $horizontal -eq $x2 ]; then
    stage="${stage}#"
  else
    stage="${stage} "
  fi
done
echo >> $LOGFILE
for (( ind=0; ind<240; ind++ )); do
  [ $(expr $ind % 40) -eq 0 ] && echo | tee -a $LOGFILE
  printf '%s' "${stage:$ind:1}" | tee -a $LOGFILE
done
echo >> $LOGFILE
echo
now=$(date +%s)
diff=$((now-started))
echo "ended: $now" >> $LOGFILE
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE