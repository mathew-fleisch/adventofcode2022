#!/bin/bash
#shellcheck disable=SC2086
convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day01-challenge1.txt}
inputFile=${1:-input.txt}
started=$(date +%s)
echo "started: $started" > $LOGFILE

# Perserve empty lines
rm -f tmp-input.txt
rm -f tmp-groups.txt
tmp=$(cat $inputFile | sed 's/^$/-/g')
echo "$tmp" > tmp-input.txt
IFS=$'\n' read -d '' -r -a values < tmp-input.txt;

inputLength=${#values[@]}
[ $DEBUG -eq 1 ] && echo "Lines: $inputLength"
echo "Lines: $inputLength" >> $LOGFILE

group=0
touch tmp-groups.txt
for line in ${values[@]}; do
    [ $DEBUG -eq 1 ] && echo "$line"

    if [[ "$line" == "-" ]]; then
        echo "$group" >> tmp-groups.txt
        group=0
    else
        group=$((line+group))
    fi
done
echo "$group" >> tmp-groups.txt
cat tmp-groups.txt | sort -nr | head -3 >> $LOGFILE
echo "..." >> $LOGFILE
echo >> $LOGFILE
cat tmp-groups.txt | sort -nr | head -1 | tee -a $LOGFILE

rm -f tmp-input.txt
rm -f tmp-groups.txt
now=$(date +%s)
diff=$((now-started))
echo "ended: $now" >> $LOGFILE
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE