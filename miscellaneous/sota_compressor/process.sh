#!/bin/bash

# get the path to this script
MY_PATH=`dirname "$0"`
MY_PATH=`( cd "$MY_PATH" && pwd )`

ROTATE=1

INPUT_DIR="input"
OUTPUT_DIR="output"
TEMP1_DIR="temp1"
TEMP2_DIR="temp2"
TEMP3_DIR="temp3"
OUTFILE="output.pdf"

mkdir $OUTPUT_DIR 2> /dev/null
mkdir $TEMP1_DIR 2> /dev/null
mkdir $TEMP2_DIR 2> /dev/null
mkdir $TEMP3_DIR 2> /dev/null

rm $TEMP1_DIR/*
rm $TEMP2_DIR/*
rm $TEMP3_DIR/*
rm $OUTPUT_DIR/*

# extract the desired pages from all pdfs
cd $MY_PATH/$INPUT_DIR
for filename in `ls *.pdf`
do 

  introduction_page=1

  # find the page where is the introduction
  for i in $(seq 1 3);
  do
    pdftk A=$filename cat A$i output temp.pdf
    pdftotext temp.pdf
    rm temp.pdf
    num=`cat temp.txt | grep -i -E 'i[[:space:]]?ntroduction|a[[:space:]]?bstract' | wc -l`
    # cat temp.txt | grep -i -E 'i[[:space:]]?ntroduction|a[[:space:]]?bstract'
    rm temp.txt
    if [ "$num" -ge "1" ]; then
      introduction_page=$i
      break 
    fi
  done

  conclusion_page=1

  # find the page where References start
  for i in $(seq 1 6);
  do
    pdftk A=$filename cat Ar$i output temp.pdf
    pdftotext temp.pdf
    rm temp.pdf
    num=`cat temp.txt | grep -i -E '^[[:space:]]*r[[:space:]]?eference(s)?' | wc -l`
    rm temp.txt
    if [ "$num" -ge "1" ]; then
      conclusion_page=$i
      break 
    fi
  done

  conclusion_page2=$(expr $conclusion_page + 1)

  # take two pages which end on references
  echo "extracting pages from $filename"
  pdftk A=$filename cat A$introduction_page Ar$conclusion_page2 Ar$conclusion_page output $MY_PATH/$TEMP1_DIR/$filename
done

# append the page with a text
cd $MY_PATH/$TEMP1_DIR
for filename in `ls *.pdf`
do 
  echo "appending tex to $filename"
  echo "$filename" > text.txt
  cupsfilter text.txt > $MY_PATH/text.pdf
  # convert $MY_PATH/text.pdf -page A4 $MY_PATH/text.pdf 
  if [ "$ROTATE" -eq "1" ]; then
    echo "rotating..."
    pdftk A=$filename B=$MY_PATH/text.pdf cat B1south A1south A2-3 output $MY_PATH/$TEMP2_DIR/$filename
  else
    pdftk A=$filename B=$MY_PATH/text.pdf cat B1 A1 A2-3 output $MY_PATH/$TEMP2_DIR/$filename
  fi
done

# convert them to double layout
cd $MY_PATH/$TEMP2_DIR
for filename in `ls *.pdf`
do 
  echo "reorganizing $filename"
  pdfnup $filename --outfile $MY_PATH/$TEMP3_DIR/$filename
done

# merge them to one pdf
cd $MY_PATH/$TEMP3_DIR
for filename in `ls *.pdf`
do 

  if [ ! -f $MY_PATH/$OUTPUT_DIR/$OUTFILE ]; then
    cp $filename $MY_PATH/$OUTPUT_DIR/$OUTFILE
  else
    pdftk A=$filename B=$MY_PATH/$OUTPUT_DIR/$OUTFILE cat B A output $MY_PATH/$OUTPUT_DIR/temp.pdf
    mv $MY_PATH/$OUTPUT_DIR/temp.pdf $MY_PATH/$OUTPUT_DIR/$OUTFILE
  fi
  echo "merging file $filename"
done
