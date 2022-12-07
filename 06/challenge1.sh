#!/bin/bash
#shellcheck disable=SC2086
convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day06-challenge1.txt}
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


len=0
answer=0
for line in "${values[@]}"; do
  [ $DEBUG -eq 1 ] && echo "$line"
  len=${#line}

  for (( i=3; i<$len; i++ )); do
    a="${line:$((i-3)):1}"
    b="${line:$((i-2)):1}"
    c="${line:$((i-1)):1}"
    d="${line:$((i-0)):1}"
    [ $DEBUG -eq 1 ] && echo "$((i-3)): $a"
    [ $DEBUG -eq 1 ] && echo "$((i-2)): $b"
    [ $DEBUG -eq 1 ] && echo "$((i-1)): $c"
    [ $DEBUG -eq 1 ] && echo "$((i-0)): $d"
    uni=$(echo "$a $b $c $d" | tr ' ' '\n' | sort | uniq | wc -l)
    [ $DEBUG -eq 1 ] && echo "-$uni------------------------"
    if [ $uni -eq 4 ]; then
      answer=$((i+1))
      break
    fi
  done
done
echo >> $LOGFILE
echo "$answer" | tee -a $LOGFILE

now=$(date +%s)
diff=$((now-started))
echo "ended: $now" >> $LOGFILE
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE