#!/bin/bash

## #{ printHelp()
function printHelp() {
 echo "Usage: ./add.sh file.bib [OPTIONS]"
 echo
 echo "   Add a bibliography record to papis database." 
 echo
 echo "Options:"
 echo "   -h, --help                 Show this message and exit." 
 echo "   -r, --ref <TEXT>           Name of the bibliography record in the papis database and the output value of the record field 'ref'." 
 echo "   -p, --pdf <PATH>           File name of the correlating pdf file." 
 echo "   -k, --keywords <TEXT>      New keywords of the bibliography record. Example: --keywords \"mine, core, journal\"." 
 echo "   -a, --addendum <TEXT>      New addendum of the bibliography record. Example: --addendum \"Q1 in Robotics.\"." 
}
## #}

# Parameters to read/set
BIB=""
REF=""
PDF=""
ADDENDUM=""
KEYWORDS=""

## #{ Parse arguments

# Check if a first argument was given
if [ $# -eq 0 ]; then
  echo "First argument (path to bib file) is mandatory."
  printHelp
  exit -1
fi
BIB=$1

POSITIONAL_ARGS=()
while [[ $# -gt 0 ]]; do
  case $1 in
    -r|--ref)
      REF="$2"
      shift # past argument
      shift # past value
      ;;
    -p|--pdf)
      PDF="$2"
      shift # past argument
      shift # past value
      ;;
    -a|--addendum)
      ADDENDUM="$2"
      shift # past argument
      shift # past value
      ;;
    -k|--keywords)
      KEYWORDS="$2"
      shift # past argument
      shift # past value
      ;;
    -h|--help)
      printHelp
      exit 0
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done

# Check if first argument is bib file (is not parameter and ends with .bib)
if [[ "$BIB" == -* ]] || [[ "$BIB" != *.bib ]]; then
  echo "First argument is mandatory to be the .bib file path."
  printHelp
  exit -2
fi

## #}

echo "###################"
echo bib:      $BIB
echo ref:      $REF
echo pdf:      $PDF
echo addendum: $ADDENDUM
echo keywords: $KEYWORDS
echo "###################"

# Add bibtex to papis
if [ -z "$REF" ]; then
  papis add --batch --from bibtex "$BIB"
else
  # Add to papis under REF keyword
  papis add --batch --from bibtex "$BIB" --folder-name "$REF"

  # Update ref field to REF keyword (force update of `ref`)
  papis update --force --doc-folder "$REF" -s ref "$REF"

  # Add pdf file
  if [ ! -z "$PDF" ]; then papis addto --doc-folder "$REF" --copy-pdf -f "$PDF"; fi

fi

# Update item parameters
if [ ! -z "$ADDENDUM" ]; then papis update --doc-folder "$REF" -s addendum "$ADDENDUM"; fi
if [ ! -z "$KEYWORDS" ]; then papis update --doc-folder "$REF" -s keywords "$KEYWORDS"; fi
