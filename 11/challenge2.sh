#!/bin/bash
#shellcheck disable=SC2001,SC2003,SC2086
convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}


DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day11-challenge2.txt}
SKIP_LONG=${SKIP_LONG:-0}
SKIP_LONG=${SKIP_LONG:-0}
precalc_filename="${LOGFILE}.tar.gz"
if [ $SKIP_LONG -eq 1 ]; then
  if [ -f "$precalc_filename" ]; then
    tar xzf $precalc_filename
  fi
  if [ -f "11/$precalc_filename" ]; then
    tar xzf 11/$precalc_filename
  fi
  if [ $SKIP_LONG -eq 1 ]; then
    last_round="33497 115568 120360 120377 33447 28580 33435 148916"
    echo "Pre-calculated: $(echo $last_round | tr ' ' '\n' | sort -n -r | head -n 2 | tr '\n' ' ' | awk '{print $1*$2}')"
    exit
  fi
fi




inputFile=${1:-input.txt}
started=$(date +%s)
echo "started: $started" > $LOGFILE

IFS=$'\n' read -d '' -r -a values < $inputFile;

inputLength=${#values[@]}
[ $DEBUG -eq 1 ] && echo "Lines: $inputLength"
echo "Lines: $inputLength" >> $LOGFILE

inspections=()
items=()
operations=()
tests=()
ttrue=()
tfalse=()
num_monkeys=0
# pull in data from input
for (( track=0; track<${#values[@]}; track=track+6 )); do
  line=${values[$track]}
  # [ $DEBUG -eq 1 ] && echo "$line"
  echo "line[$track]: $line" >> $LOGFILE

  # New Monkey
  if [[ "$line" =~ ^Monkey ]]; then
    num_monkeys=$((num_monkeys+1))
    this_monkey=$(echo "${values[$track]}" | sed -e 's/Monkey \([0-9][0-9]*\):*/\1/g')
    this_item=$(echo "${values[$((track+1))]}" | cut -d: -f2 | sed -e 's/\ //g' | sed -e 's/,/ /g')
    this_operation=$(echo "${values[$((track+2))]}" | cut -d= -f2 | sed -e 's/^\ old\ //g' | sed -e 's/\ //g')
    this_test=$(echo "${values[$((track+3))]}" | sed -e 's/.*by\ //g')
    this_true=$(echo "${values[$((track+4))]}" | sed -e 's/.*monkey\ //g')
    this_false=$(echo "${values[$((track+5))]}" | sed -e 's/.*monkey\ //g')

    [ $DEBUG -eq 1 ] && echo "$this_monkey|${this_test}?${this_true}:${this_false}|${this_operation}|${this_item}"
    items[$this_monkey]=${this_item}
    operations[$this_monkey]=${this_operation}
    tests[$this_monkey]=${this_test}
    ttrue[$this_monkey]=${this_true}
    tfalse[$this_monkey]=${this_false}
  fi
done
echo "Unique primes: ${tests[@]}" >> $LOGFILE
magic_number=1
for n in ${tests[@]}; do
  magic_number=$((magic_number*n))
done
echo "Magic Number: $magic_number" >> $LOGFILE
for (( round=1; round<=10000; round++ )); do
  now=$(date +%s)
  diff=$((now-started))
  [ $DEBUG -eq 1 ] && echo "<---------------- Round[$round][$(date)][$(convertsecs $diff)] ---------------->"
  echo "<---------------- Round[$round][$(date)][$(convertsecs $diff)] ---------------->" >> $LOGFILE
  for (( monkey=0; monkey<=num_monkeys-1; monkey++ )); do
    this_operation=${operations[$monkey]}
    for item in ${items[$monkey]}; do
      new_item=0
      if [ "$this_operation" == "*old" ]; then
        new_item=$((item*item))
        inspections[$monkey]=$((inspections[monkey]+1))
      else
        if [ "${this_operation:0:1}" == "*" ]; then
          val=${this_operation:1}
          new_item=$((item*val))
          inspections[$monkey]=$((inspections[monkey]+1))
        else
          val=${this_operation:1}
          new_item=$((item+val))
          inspections[$monkey]=$((inspections[monkey]+1))
        fi
      fi
      new_item=$((new_item%magic_number))
      if [ $((new_item%tests[monkey])) -eq 0 ]; then
        throw_to=${ttrue[$monkey]}
      else
        throw_to=${tfalse[$monkey]}
      fi
      items[$monkey]=$(echo "${items[$monkey]}" | sed -e 's/^\s*//g' | sed -e 's/^'$item'//g')
      items[$throw_to]="$(echo "${items[$throw_to]}" | sed -e 's/^\s*//g') $new_item"
    done
  done

  for (( tmonkey=0; tmonkey<=num_monkeys-1; tmonkey++ )); do
    items[$tmonkey]=$(echo "${items[$tmonkey]}" | sed -e 's/\ \ */\ /g' | sed -e 's/^\ //g')
    [ $DEBUG -eq 1 ] && echo "Monkey[${round}][${tmonkey}]: ${inspections[$tmonkey]}"
    echo "Monkey[${round}][${tmonkey}]: ${inspections[$tmonkey]}" >> $LOGFILE
  done
done
[ $DEBUG -eq 1 ] && echo "${inspections[@]}" | tr ' ' '\n' | sort -n -r
answer=$(echo "${inspections[@]}" | tr ' ' '\n' | sort -n -r | head -n 2 | tr '\n' ' ' | awk '{print $1*$2}')

echo >> $LOGFILE
echo "$answer" | tee -a $LOGFILE

now=$(date +%s)
diff=$((now-started))
echo "ended: $now" >> $LOGFILE
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE