#!/bin/bash
#shellcheck disable=SC2086
source ../common.sh

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day01-challenge1.txt}
inputFile=${1:-input.txt}
started=$(date +%s)
echo "started: $started" > $LOGFILE

# Perserve empty lines
rm -f tmp-input.txt
tmp=$(cat $inputFile | sed 's/^$/-/g')
echo "$tmp" > tmp-input.txt
IFS=$'\n' read -d '' -r -a values < tmp-input.txt;

inputLength=${#values[@]}
[ $DEBUG -eq 1 ] && echo "Lines: $inputLength"
echo "Lines: $inputLength" >> $LOGFILE

highest=0
group=0
for line in ${values[@]}; do
    [ $DEBUG -eq 1 ] && echo "$line"

    if [[ "$line" == "-" ]]; then
        if [ $group -gt $highest ]; then
            highest=$group
        fi
        group=0
    else
        group=$((line+group))
    fi
done
echo "highest: $highest" | tee -a $LOGFILE

rm -f tmp-input.txt
now=$(date +%s)
diff=$((now-started))
echo "ended: $now" >> $LOGFILE
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE