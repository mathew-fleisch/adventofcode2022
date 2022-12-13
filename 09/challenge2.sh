#!/bin/bash
#shellcheck disable=SC2086
convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day09-challenge2.txt}
SKIP_LONG=${SKIP_LONG:-0}
precalc_filename="${LOGFILE}.tar.gz"
if [ $SKIP_LONG -eq 1 ]; then
  if [ -f "$precalc_filename" ]; then
    tar xzf $precalc_filename
  fi
  if [ -f "09/$precalc_filename" ]; then
    tar xzf 09/$precalc_filename
  fi
  
  echo "Pre-calculated: 2717"
  exit
fi
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

height=100
half=$((height/2))
# Initialize the snake (rope)
snake_length=10
snake_sections="H123456789"
snake=()
for (( sinit=0; sinit<$snake_length; sinit++ )); do
  snake+=( "$half,$half" )
done
tail_visited="$half,$half"
display_stage() {
  stage=()
  for (( y=0; y<$height; y++ )); do
    row=""
    for (( x=0; x<$height; x++ )); do
      issnek=0
      if [ $x -eq $half ] && [ $y -eq $half ]; then
        row="${row}s"
      else
        for (( ssection=0; ssection<$snake_length; ssection++ )); do
          if [[ "$x,$y" == "${snake[$ssection]}" ]]; then
            row="${row}${snake_sections:$ssection:1}"
            issnek=1
            break
          fi
        done
        [ $issnek -eq 0 ] && row="${row}.";
      fi
    done
    stage+=( $row )
  done
  echo "${stage[@]}" | tr ' ' '\n'
}
display_tail_trail() {
  stage=()
  for (( y=0; y<$height; y++ )); do
    row=""
    for (( x=0; x<$height; x++ )); do
      found=$(echo $tail_visited | tr ' ' '\n' | sort | uniq | grep -E "^$x,$y$")
      if [ $x -eq $half ] && [ $y -eq $half ]; then
          row="${row}s"
      elif [ -n "$found" ]; then
          row="${row}#"
      else
        row="${row}."
      fi
    done
    stage+=( $row )
  done
  echo "${stage[@]}" | tr ' ' '\n'
}
display_snake_positions() {
  for (( spos=0; spos<$snake_length; spos++ )); do
    echo "${snake_sections:$spos:1}: ${snake[$spos]}"
  done
}
# Display x,y positions of the snake
[ $DEBUG -eq 1 ] && echo "Initializing snake at $half,$half: $snake_length"
[ $DEBUG -eq 1 ] && display_snake_positions

snek() {
  headindex=$1
  tailindex=$((headindex+1))
  headx=$2
  heady=$3
  tailx=$4
  taily=$5
  # echo "head[$headindex]($headx,$heady)====>tail[$tailindex]($tailx,$taily)"
  move_tail=1
  for (( cx=-1; cx<2; cx++ )); do
    for (( cy=-1; cy<2; cy++ )); do
      comparex=$((tailx+cx))
      comparey=$((taily+cy))
      # echo "$comparex ?= $headx | $comparey ?= $heady"
      if [ $comparex -eq $headx ] && [ $comparey -eq $heady ]; then
        move_tail=0
        # echo "$(display_snake_positions)"
        # echo "Do NOT move tail section s[$tailindex][$tailx,$taily] too close to s[$headindex][$headx,$heady] too close to move..."
        break 3
      fi
    done
  done
  if [ $move_tail -eq 1 ]; then
    # Southeast
    if [ $headx -eq $((tailx+1)) ] && [ $heady -eq $((taily+2)) ]; then
      tailx=$((tailx+1))
      taily=$((taily+1))
    # Northeast
    elif [ $headx -eq $((tailx+1)) ] && [ $heady -eq $((taily-2)) ]; then
      tailx=$((tailx+1))
      taily=$((taily-1))
    # Northwest
    elif [ $headx -eq $((tailx-1)) ] && [ $heady -eq $((taily-2)) ]; then
      tailx=$((tailx-1))
      taily=$((taily-1))
    # Southwest
    elif [ $headx -eq $((tailx-1)) ] && [ $heady -eq $((taily+2)) ]; then
      tailx=$((tailx-1))
      taily=$((taily+1))
    # Southeast
    elif [ $headx -eq $((tailx+2)) ] && [ $heady -eq $((taily+1)) ]; then
      tailx=$((tailx+1))
      taily=$((taily+1))
    # Northeast
    elif [ $headx -eq $((tailx+2)) ] && [ $heady -eq $((taily-1)) ]; then
      tailx=$((tailx+1))
      taily=$((taily-1))
    # Northwest
    elif [ $headx -eq $((tailx-2)) ] && [ $heady -eq $((taily-1)) ]; then
      tailx=$((tailx-1))
      taily=$((taily-1))
    # Southwest
    elif [ $headx -eq $((tailx-2)) ] && [ $heady -eq $((taily+1)) ]; then
      tailx=$((tailx-1))
      taily=$((taily+1))
    else
      # Right
      if [ $headx -eq $((tailx+2)) ]; then
        tailx=$((tailx+1))
      fi
      # Left
      if [ $headx -eq $((tailx-2)) ]; then
        tailx=$((tailx-1))
      fi
      # Down
      if [ $heady -eq $((taily+2)) ]; then
        taily=$((taily+1))
      fi
      # Up
      if [ $heady -eq $((taily-2)) ]; then
        taily=$((taily-1))
      fi
    fi

    snake[$tailindex]="$tailx,$taily"
  fi
}

track=0
for line in "${values[@]}"; do
  # [ $DEBUG -eq 1 ] && echo "line: $line"
  echo "line[$track]: $line" >> $LOGFILE
  direction=$(echo "$line" | awk '{print $1}')
  duration=$(echo "$line" | awk '{print $2}')
  # [ $DEBUG -eq 1 ] && echo "$direction: $duration"
  # display_stage
  # echo "move_snake(direction: '$direction', duration: '$duration')"
  for (( m=1; m<=$duration; m++ )); do
    prevx=""
    prevy=""
    pull=0

    headx=$(echo "${snake[0]}" | cut -d, -f1)
    heady=$(echo "${snake[0]}" | cut -d, -f2)
    newx=$headx
    newy=$heady
    case $direction in
    U) newy=$((heady-1)) ;;
    D) newy=$((heady+1)) ;;
    R) newx=$((headx+1)) ;;
    L) newx=$((headx-1)) ;;
    esac
    # echo "<======== New HEAD Position: $headx,$heady=>$newx,$newy ========>"
    snake[0]="$newx,$newy"
    for (( s=0; s<$snake_length-1; s++ )); do
      headx=$(echo "${snake[$s]}" | cut -d, -f1)
      heady=$(echo "${snake[$s]}" | cut -d, -f2)
      tailx=$(echo "${snake[$((s+1))]}" | cut -d, -f1)
      taily=$(echo "${snake[$((s+1))]}" | cut -d, -f2)
      snek $s $headx $heady $tailx $taily
    done
    tail_visited="$tail_visited ${snake[9]}"
  done
  [ $DEBUG -eq 1 ] && display_stage
  track=$((track+1))
done
echo "$tail_visited" | tr ' ' '\n' | sort | uniq >> $LOGFILE
echo "------------------------------" >> $LOGFILE
display_tail_trail >> $LOGFILE
echo "------------------------------" >> $LOGFILE
answer=$(echo "$tail_visited" | tr ' ' '\n' | sort | uniq | wc -l | awk '{print $1}')
echo >> $LOGFILE
echo "$answer" | tee -a $LOGFILE

now=$(date +%s)
diff=$((now-started))
echo "ended: $now" >> $LOGFILE
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE