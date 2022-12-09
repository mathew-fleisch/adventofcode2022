#!/bin/bash
#shellcheck disable=SC2086,SC2004
convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day08-challenge2.txt}
inputFile=${1:-input.txt}
started=$(date +%s)
echo "started: $started" > $LOGFILE

IFS=$'\n' read -d '' -r -a values < $inputFile;

inputLength=${#values[@]}
[ $DEBUG -eq 1 ] && echo "lines: $inputLength"
height=$((inputLength-1))
echo "height/width: $height" >> $LOGFILE

isVisible() {
  x=$1
  y=$2
  char=$3
  [ $DEBUG -eq 1 ] && echo "isVisible($x, $y, $char)" >> $LOGFILE
  i=$x
  j=$y
  # All trees around the paremeter are visible
  if [ $x -eq 0 ] || [ $y -eq 0 ] || [ $x -eq $height ] || [ $y -eq $height ]; then
    echo "1" && return
  fi
  # Up x,y-- (if x,y is greater than all i,j values, it is visible)
  up_vis=0
  for (( j=$y-1; j>=0; j-- )); do
    comp=${values[$j]:$i:1}
    [ $DEBUG -eq 1 ] && echo "($x,$y) $char ?> $comp ($i,$j)" >> $LOGFILE
    up_vis=$((up_vis+1))
    if [ $comp -ge $char ]; then
      [ $DEBUG -eq 1 ] && echo "not visible" >> $LOGFILE
      break
    fi
  done
  i=$x
  j=$y

  # Down x,y++ (if x,y is greater than all i,j values, it is visible)
  down_vis=0
  for (( j=$y+1; j<=$height; j++ )); do
    comp=${values[$j]:$i:1}
    [ $DEBUG -eq 1 ] && echo "($x,$y) $char ?> $comp ($i,$j)" >> $LOGFILE
    down_vis=$((down_vis+1))
    if [ $comp -ge $char ]; then
      [ $DEBUG -eq 1 ] && echo "not visible" >> $LOGFILE
      break
    fi
  done
  i=$x
  j=$y

  # Left x--,y (if x,y is greater than all i,j values, it is visible)
  left_vis=0
  for (( i=$x-1; i>=0; i-- )); do
    comp=${values[$j]:$i:1}
    [ $DEBUG -eq 1 ] && echo "($x,$y) $char ?> $comp ($i,$j)" >> $LOGFILE
    left_vis=$((left_vis+1))
    if [ $comp -ge $char ]; then
      [ $DEBUG -eq 1 ] && echo "not visible" >> $LOGFILE
      break
    fi
  done
  i=$x
  j=$y

  # Right x++,y (if x,y is greater than all i,j values, it is visible)
  right_vis=0
  for (( i=$x+1; i<=$height; i++ )); do
    comp=${values[$j]:$i:1}
    [ $DEBUG -eq 1 ] && echo "($x,$y) $char ?> $comp ($i,$j)" >> $LOGFILE
    right_vis=$((right_vis+1))
    if [ $comp -ge $char ]; then
      [ $DEBUG -eq 1 ] && echo "not visible" >> $LOGFILE
      break
    fi
  done
  score=$((up_vis*down_vis*left_vis*right_vis))
  echo "$score" | tee -a $LOGFILE && return
}

highest=0
for (( y=0; y<$inputLength; y++ )); do
  line=${values[$y]}
  for (( x=0; x<${#line}; x++ )); do
    this_char="${line:$x:1}"
    score=$(isVisible $x $y $this_char)
    if [ $score -gt $highest ]; then
      highest=$score
    fi
    [ $DEBUG -eq 1 ] && echo "$x,$y: $this_char: $score"
  done
done
echo >> $LOGFILE
echo "$highest" | tee -a $LOGFILE

now=$(date +%s)
diff=$((now-started))
echo "ended: $now" >> $LOGFILE
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE