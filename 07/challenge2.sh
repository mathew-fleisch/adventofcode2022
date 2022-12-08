#!/bin/bash
#shellcheck disable=SC2086
convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}

DEBUG=${DEBUG:-0}
LOGFILE=${LOGFILE:-log-day07-challenge2.txt}
LOGFILE="${PWD}/$LOGFILE"
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
starting_at=${PWD}
for line in "${values[@]}"; do
    if [[ "$line" == "$ cd /" ]]; then
      rm -rf stage
      mkdir -p stage
      pushd stage &>> $LOGFILE
      continue
    fi
    if [[ "$line" == "$ ls" ]]; then
     continue
    fi
    if [[ "$line" =~ ^\$ ]] || [[ "$line" =~ ^dir ]]; then
      line=$(echo "$line" | sed -e 's/^\$\ //g')
      [ $DEBUG -eq 1 ] && echo "Command: $line"
      echo "Command: $line" >> $LOGFILE
      dir=$(echo "$line" | awk '{print $2}')
      if [[ "$line" =~ ^dir ]]; then
        mkdir $dir
      else
        if [[ "$dir" == ".." ]]; then
          popd &>> $LOGFILE
        else
          pushd $dir &>> $LOGFILE
        fi
      fi
    else
      [ $DEBUG -eq 1 ] && echo "File:    $line"
      filesize=$(echo "$line" | awk '{print $1}')
      filename=$(echo "$line" | awk '{print $2}' | sed -e 's/$/.txt/g')
      echo "$filesize" > $filename
    fi
done
cd $starting_at/stage
[ $DEBUG -eq 1 ] && tree | tee -a $LOGFILE
touch summary.txt
for dir in $(find . -type d); do
  sum=$(find $dir -type f -name "*.txt" | xargs -I {} cat {} | awk '{ sum += $1 } END { print sum }')
  echo "$dir: $sum" >> summary.txt
  echo "$dir: $sum" >> $LOGFILE
done
total=0
for smallest in $(cat summary.txt| tail -n +2 | awk '{print $2}' | sort -n); do
  total=$((toal+smallest))
  if [ $total -ge 1072708 ]; then
    answer=$total
    break
  fi
done
echo >> $LOGFILE
echo "$answer" | tee -a $LOGFILE
cd $starting_at
[ $DEBUG -ne 1 ] && rm -rf stage

now=$(date +%s)
diff=$((now-started))
echo "ended: $now" >> $LOGFILE
echo "Completed in: $(convertsecs $diff)" >> $LOGFILE