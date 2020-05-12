#!/bin/bash

tohtml() {

  # ARGUMENT PARSING
  # Do not overwrite (0) or overwrite (1)
  OVERWRITE="$1"
  # Syntax chosen for the wiki
  SYNTAX="$2"
  # File extension for the wiki
  EXTENSION="$3"
  # Full path of the output directory
  OUTPUTDIR="$4"
  # Full path of the wiki page
  INPUT="$5"
  # Full path to the wiki's template
  TEMPLATE_PATH="$6"
  # The default template name
  TEMPLATE_DEFAULT="$7"
  # The extension of template files
  TEMPLATE_EXT="$8"
  # Count of '../' for pages buried in subdirs
  ROOT_PATH="${9}"

  # If file is in vimwiki base dir, the root path is '-'
  [[ "$ROOT_PATH" = "-" ]] && ROOT_PATH=''

  # Example: index.md
  FILE=$(basename "$INPUT")
  # Example: index
  FILENAME=$(basename "$INPUT" ."$EXTENSION")
  # Example: /home/rattletat/wiki/text/uni/
  FILEPATH=${INPUT%$FILE}
  # Example: /home/rattletat/wiki/html/uni/index
  OUTPUT=$OUTPUTDIR$FILENAME

  # PANDOC ARGUMENTS

  # If you have Mathjax locally use this:
  MATHJAX="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
  # MATHJAX="/usr/share/mathjax/MathJax.js?config=TeX-AMS-MML_HTMLorMML"

  # PREPANDOC PROCESSING AND PANDOC

  pandoc_template="pandoc \
      --mathjax=$MATHJAX \
      --template=$TEMPLATE_PATH$TEMPLATE_DEFAULT$TEMPLATE_EXT \
      --metadata pagetitle="test" \
      --self-contained \
      -f $SYNTAX \
      -t html \
      -M root_path:$ROOT_PATH"

  # Searches for markdown links (without extension or .md) and appends a .html
  regex1='s/(\[.+\])\(([^.)]+)(\.md)?\)/\1(\2.html)/g'
  # Removes placeholder title from vimwiki markdown file
  regex2='s/^%title (.+)$/---\ntitle: \1\n---/'

  pandoc_input=$(cat "$INPUT" | sed -r "$regex1;$regex2")
  pandoc_output=$(echo "$pandoc_input" | $pandoc_template)

  # POSTPANDOC PROCESSING

  # Removes "file" from ![pic of sharks](file:../sharks.jpg)
  regex3='s/file://g'

  echo "$pandoc_output" | sed -r $regex3 > "$OUTPUT.html"
}

FILEDIR="$( cd "$( dirname "$1" )" && pwd )"
echo dir: $FILEDIR
BASENAME=`basename "$1"`
echo file name: $BASENAME

# Do not overwrite (0) or overwrite (1)
OVERWRITE=1
# Syntax chosen for the wiki
SYNTAX=markdown
# File extension for the wiki
EXTENSION=.md
# Full path of the output directory
OUTPUTDIR=/tmp/mdhtml/
# Full path of the wiki page
INPUT=$1
# Full path to the wiki's template
TEMPLATE_PATH=~/git/linux-setup/submodules/pandoc-goodies/templates/html5/github/
# The default template name
TEMPLATE_DEFAULT=GitHub
# The extension of template files
TEMPLATE_EXT=.html5
# Count of '../' for pages buried in subdirs
ROOT_PATH=""

mkdir -p "$OUTPUTDIR"

tohtml $OVERWRITE $SYNTAX $EXTENSION $OUTPUTDIR $INPUT $TEMPLATE_PATH $TEMPLATE_DEFAULT $TEMPLATE_EXT $ROOT_PATH

xdg-open $OUTPUTDIR/$BASENAME.html
