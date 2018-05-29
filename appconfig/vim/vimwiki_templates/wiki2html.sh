#!/bin/bash

FORCE="$1"
SYNTAX="$2"
EXTENSION="$3"
OUTPUTDIR="$4"
INPUT="$5"
CSSFILE="$6"

FILE=$(basename "$INPUT")
FILENAME=$(basename "$INPUT" .$EXTENSION)
OUTPUT="$OUTPUTDIR"/$FILENAME
CSSFILENAME=$(basename "$6")

HAS_MATH=$(grep -o "\$\$.\+\$\$" "$INPUT")
if [ ! -z "$HAS_MATH" ]; then
    MATH="--mathjax=https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
else
    MATH=""
fi

# >&2 echo "MATH: $MATH"

sed -r 's/(\[.+\])\(([^)]+)\)/\1(\2.html)/g' <"$INPUT" | pandoc $MATH -s -f $SYNTAX -t html -c $CSSFILENAME | sed -r 's/<li>(.*)\[ \]/<li class="todo done0">\1/g; s/<li>(.*)\[X\]/<li class="todo done4">\1/g' > "$OUTPUT.html"
