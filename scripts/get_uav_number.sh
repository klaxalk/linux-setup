TEMP_FILE=/tmp/uav_number.txt
BLOCKING=""

if [ ! -e $TEMP_FILE ]; then
  BLOCKING=1
fi

~/.i3/detacher.sh $BLOCKING "rostopic list | grep set_reference | head -n 1 | tr '/' ' ' | awk '{print \$1}' | sed 's/uav//' >> $TEMP_FILE" > /dev/null 2>&1
cat $TEMP_FILE | tail -n 1
