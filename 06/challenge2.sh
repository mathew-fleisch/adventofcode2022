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

  for (( i=13; i<$len; i++ )); do
    a="${line:$((i-13)):1}"
    b="${line:$((i-12)):1}"
    c="${line:$((i-11)):1}"
    d="${line:$((i-10)):1}"
    e="${line:$((i-9)):1}"
    f="${line:$((i-8)):1}"
    g="${line:$((i-7)):1}"
    h="${line:$((i-6)):1}"
    j="${line:$((i-5)):1}"
    k="${line:$((i-4)):1}"
    l="${line:$((i-3)):1}"
    m="${line:$((i-2)):1}"
    n="${line:$((i-1)):1}"
    o="${line:$((i-0)):1}"
    [ $DEBUG -eq 1 ] && echo "$((i-13)): $a"
    [ $DEBUG -eq 1 ] && echo "$((i-12)): $b"
    [ $DEBUG -eq 1 ] && echo "$((i-11)): $c"
    [ $DEBUG -eq 1 ] && echo "$((i-10)): $d"
    [ $DEBUG -eq 1 ] && echo "$((i-9)): $e"
    [ $DEBUG -eq 1 ] && echo "$((i-8)): $f"
    [ $DEBUG -eq 1 ] && echo "$((i-7)): $g"
    [ $DEBUG -eq 1 ] && echo "$((i-6)): $h"
    [ $DEBUG -eq 1 ] && echo "$((i-5)): $j"
    [ $DEBUG -eq 1 ] && echo "$((i-4)): $k"
    [ $DEBUG -eq 1 ] && echo "$((i-3)): $l"
    [ $DEBUG -eq 1 ] && echo "$((i-2)): $m"
    [ $DEBUG -eq 1 ] && echo "$((i-1)): $n"
    [ $DEBUG -eq 1 ] && echo "$((i-0)): $o"
    uni=$(echo "$a $b $c $d $e $f $g $h $j $k $l $m $n $o" | tr ' ' '\n' | sort | uniq | wc -l)
    [ $DEBUG -eq 1 ] && echo "-$uni------------------------"
    if [ $uni -eq 14 ]; then
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