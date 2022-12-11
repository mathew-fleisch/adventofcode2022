#!/bin/bash
#shellcheck disable=SC2086
convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day09-challenge1.txt}
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
height=99
half=$((height/2))
stage=()
for (( y=0; y<$height; y++ )); do
  row=""
  for (( x=0; x<$height; x++ )); do
    if [ $x -eq $half ] && [ $y -eq $half ]; then
      row="${row}H"
    else
      row="${row}."
    fi
  done
  stage+=( $row )
done

hx=$half
hy=$half
tx=$half
ty=$half
tail_visited="$tx,$ty"
track=0
for line in "${values[@]}"; do
  echo "line[$track]: $line" >> $LOGFILE
  direction=$(echo "$line" | awk '{print $1}')
  duration=$(echo "$line" | awk '{print $2}')
  for (( m=1; m<=$duration; m++ )); do
    hbx=$hx
    hby=$hy
    case $direction in
    U) hy=$((hy-1)) ;;
    D) hy=$((hy+1)) ;;
    R) hx=$((hx+1)) ;;
    L) hx=$((hx-1)) ;;
    esac
    move_tail=1
    for (( cx=-1; cx<2; cx++ )); do
      for (( cy=-1; cy<2; cy++ )); do
        comparex=$((tx+cx))
        comparey=$((ty+cy))
        if [ $comparex -eq $hx ] && [ $comparey -eq $hy ]; then
          move_tail=0
          break 2
        fi
      done
    done
    if [ $move_tail -eq 1 ]; then
      tx=$hbx
      ty=$hby
      tail_visited="$tail_visited $tx,$ty"
    fi

    if [ $DEBUG -eq 1 ]; then
      echo "-${hx},${hy}-${tx},${ty}----------------" | tee -a $LOGFILE
      echo "$track: $line" | tee -a $LOGFILE
      stage=()
      for (( y=0; y<$height; y++ )); do
        row=""
        for (( x=0; x<$height; x++ )); do
          if [ $x -eq $hx ] && [ $y -eq $hy ]; then
            row="${row}H"
          elif [ $x -eq $tx ] && [ $y -eq $ty ]; then
            row="${row}T"
          else
            row="${row}."
          fi
        done
        stage+=( $row )
      done
      echo "${stage[@]}" | tr ' ' '\n'
    fi

  done
done
echo "$tail_visited" | tr ' ' '\n' | sort | uniq >> $LOGFILE
answer=$(echo "$tail_visited" | tr ' ' '\n' | sort | uniq | wc -l | awk '{print $1}')
echo >> $LOGFILE
echo "$answer" | tee -a $LOGFILE

now=$(date +%s)
diff=$((now-started))
echo "ended: $now" >> $LOGFILE
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE