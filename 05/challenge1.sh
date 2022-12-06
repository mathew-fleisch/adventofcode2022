#!/bin/bash
#shellcheck disable=SC2086
# set -o pipefail
# set -x
convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day05-challenge1.txt}
inputFile=${1:-input.txt}
started=$(date +%s)
echo "started: $started" > $LOGFILE

IFS=$'\n' read -d '' -r -a values < $inputFile;

inputLength=${#values[@]}
[ $DEBUG -eq 1 ] && echo "Lines: $inputLength"
echo "Lines: $inputLength" >> $LOGFILE

if ! declare -A stacks 2> /dev/null ; then
  echo "Associative arrays not supported with this version of bash! Upgrade bash, or use the container provided."
  /bin/bash --version | head -1
  exit
fi

for col in {1..9}; do
  stacks[$col]=""
  for row in $(cat $inputFile | head -n 8 | sed -e 's/\ \ \ \ /[_] /g' | sed -e 's/\]\[/] [/g' | sed -e 's/\[*\]*//g' | awk '{print $'$col'}' | awk '{ x = $0 "\n" x } END { printf "%s", x }' | sed -e 's/_//g'); do
    stacks[$col]="${stacks[$col]} $row"
  done
done

unset col
unset row

for col in {1..9}; do
  if [ -n "${stacks[$col]}" ]; then
    stacks[$col]=$(echo "${stacks[$col]}" | tr ' ' '\n' | sed -e '/^$/d' | tr '\n' ' ')
  fi
done

for line in "${values[@]}"; do
    if [[ "$line" =~ ^move ]]; then
      instruct=$(echo "$line" | sed -e 's/move*\|from*\|to*//g')
      unit=$(echo "$instruct" | awk '{print $1}')
      from=$(echo "$instruct" | awk '{print $2}')
      dest=$(echo "$instruct" | awk '{print $3}')
      move=$(echo "${stacks[$from]}" | tr ' ' '\n' | tail -n $unit | awk '{ x = $0 "\n" x } END { printf "%s", x }' | tr '\n' ' ')
      fromCount=$(echo "${stacks[$from]}" | tr ' ' '\n' | wc -l | awk '{print $1}')
      nfromCount=$((fromCount-unit))
      nfrom=$(echo "${stacks[$from]}" | tr ' ' '\n' | head -n $nfromCount | tr '\n' ' ')
      ndest="${stacks[$dest]} $move"
      stacks[$from]=$(echo "$nfrom" | tr ' ' '\n' | sed -e '/^$/d' | tr '\n' ' ')
      stacks[$dest]=$(echo "$ndest" | tr ' ' '\n' | sed -e '/^$/d' | tr '\n' ' ')
    fi
done

answer=""
for col in {1..9}; do
  if [ -n "${stacks[$col]}" ]; then
    answer="${answer}$(echo "${stacks[$col]}" | tr ' ' '\n' | sed -e '/^$/d' | tail -n 1)"
  fi
done

echo >> $LOGFILE
echo "$answer" | tee -a $LOGFILE

now=$(date +%s)
diff=$((now-started))
echo "ended: $now" >> $LOGFILE
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE