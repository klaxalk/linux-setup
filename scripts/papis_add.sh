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
if [[ "$BIB" == -* ]] || [[ "$BIB" != *.bib ]] || [ ! -f "$BIB" ]; then
  echo "First argument is mandatory to be an existing .bib file path."
  printHelp
  exit -2
fi

## #}

COLOR_HIGHLIGHT='\033[0;32m'
STYLE_NONE='\033[0m'
TEXT_BOLD='\033[1m'
echo "###################"
echo -e bib:      ${COLOR_HIGHLIGHT}$BIB${STYLE_NONE}
echo -e ref:      ${COLOR_HIGHLIGHT}${TEXT_BOLD}$REF${STYLE_NONE}
echo -e pdf:      ${COLOR_HIGHLIGHT}$PDF${STYLE_NONE}
echo -e addendum: ${COLOR_HIGHLIGHT}$ADDENDUM${STYLE_NONE}
echo -e keywords: ${COLOR_HIGHLIGHT}$KEYWORDS${STYLE_NONE}
echo "###################"

## #{ Preprocess input bib file

# Get vim
if [ -x "$(whereis nvim | awk '{print $2}')" ]; then
  VIM_BIN="$(whereis nvim | awk '{print $2}')"
  HEADLESS="--headless"
elif [ -x "$(whereis vim | awk '{print $2}')" ]; then
  VIM_BIN="$(whereis vim | awk '{print $2}')"
  HEADLESS=""
fi

# Copy bib file
cp "$BIB" /tmp/tmp.bib
BIB=/tmp/tmp.bib

# Replace czech characters
$VIM_BIN $HEADLESS -nEs -c '%g/author.*=/s/{//g' -c "wqa" -- "$BIB"
$VIM_BIN $HEADLESS -nEs -c '%g/author.*=/s/}//g' -c "wqa" -- "$BIB"

$VIM_BIN $HEADLESS -nEs -c '%s/ě/e/g' -c "wqa" -- "$BIB"
$VIM_BIN $HEADLESS -nEs -c '%s/š/s/g' -c "wqa" -- "$BIB"
$VIM_BIN $HEADLESS -nEs -c '%s/č/c/g' -c "wqa" -- "$BIB"
$VIM_BIN $HEADLESS -nEs -c '%s/ř/r/g' -c "wqa" -- "$BIB"
$VIM_BIN $HEADLESS -nEs -c '%s/ž/z/g' -c "wqa" -- "$BIB"
$VIM_BIN $HEADLESS -nEs -c '%s/ý/y/g' -c "wqa" -- "$BIB"
$VIM_BIN $HEADLESS -nEs -c '%s/á/a/g' -c "wqa" -- "$BIB"
$VIM_BIN $HEADLESS -nEs -c '%s/í/i/g' -c "wqa" -- "$BIB"
$VIM_BIN $HEADLESS -nEs -c '%s/é/e/g' -c "wqa" -- "$BIB"

$VIM_BIN $HEADLESS -nEs -c '%g/author.*=/s/\\v//g' -c "wqa" -- "$BIB"
$VIM_BIN $HEADLESS -nEs -c "%g/author.*=/s/\\\'//g" -c "wqa" -- "$BIB"

$VIM_BIN $HEADLESS -nEs -c '%g/author.*=/norm f=wi{$a F,i}' -c "wqa" -- "$BIB"

# Remove double {{ }} from title
$VIM_BIN $HEADLESS -nEs -c '%g/title.*=/s/{//g' -c "wqa" -- "$BIB"
$VIM_BIN $HEADLESS -nEs -c '%g/title.*=/s/}//g' -c "wqa" -- "$BIB"
$VIM_BIN $HEADLESS -nEs -c '%g/title.*=/norm f=wi{$a F,i}' -c "wqa" -- "$BIB"

# Month field correction
$VIM_BIN $HEADLESS -nEs -c '%g/month.*=.*/s/}//g' -c "wqa" -- "$BIB" # delete } brackets around the month
$VIM_BIN $HEADLESS -nEs -c '%g/month.*=.*/s/{//g' -c "wqa" -- "$BIB" # delete { brackets around the month
$VIM_BIN $HEADLESS -nEs -c '%g/month.*=/norm Vu' -c "wqa" -- "$BIB" # lowercase
$VIM_BIN $HEADLESS -nEs -c '%g/month.*=/s/january/1' -c "wqa" -- "$BIB"
$VIM_BIN $HEADLESS -nEs -c '%g/month.*=/s/february/2' -c "wqa" -- "$BIB"
$VIM_BIN $HEADLESS -nEs -c '%g/month.*=/s/march/3' -c "wqa" -- "$BIB"
$VIM_BIN $HEADLESS -nEs -c '%g/month.*=/s/april/4' -c "wqa" -- "$BIB"
$VIM_BIN $HEADLESS -nEs -c '%g/month.*=/s/may/5' -c "wqa" -- "$BIB"
$VIM_BIN $HEADLESS -nEs -c '%g/month.*=/s/june/6' -c "wqa" -- "$BIB"
$VIM_BIN $HEADLESS -nEs -c '%g/month.*=/s/july/7' -c "wqa" -- "$BIB"
$VIM_BIN $HEADLESS -nEs -c '%g/month.*=/s/august/8' -c "wqa" -- "$BIB"
$VIM_BIN $HEADLESS -nEs -c '%g/month.*=/s/september/9' -c "wqa" -- "$BIB"
$VIM_BIN $HEADLESS -nEs -c '%g/month.*=/s/october/10' -c "wqa" -- "$BIB"
$VIM_BIN $HEADLESS -nEs -c '%g/month.*=/s/november/11' -c "wqa" -- "$BIB"
$VIM_BIN $HEADLESS -nEs -c '%g/month.*=/s/december/12' -c "wqa" -- "$BIB"

# Ensure there is -- between ranges
$VIM_BIN $HEADLESS -nEs -c '%g/pages.*=/s/\d\zs-\ze\d/--' -c "wqa" -- "$BIB"
$VIM_BIN $HEADLESS -nEs -c '%g/issn.*=/s/\d\zs-\ze\d/--' -c "wqa" -- "$BIB"

## #}

# Get papis database directory
PAPIS_DIR=`papis -l papers config dirs | cut -d "\"" -f2` # find dirs specified in papis config, e.g., ["~/git/bibligraphy", "~/Dropbox/papers"] # EPIGEN...
if [[ "$PAPIS_DIR" = ~\/* ]]; then PAPIS_DIR="${PAPIS_DIR/#\~/$HOME}"; fi # expand tilde

if [ ! -d "$PAPIS_DIR" ]; then
  echo -e "Could not find path to papis ${COLOR_HIGHLIGHT}papers${STYLE_NONE} database:"
  echo -e "   ${COLOR_HIGHLIGHT}papis -l papers config dirs${STYLE_NONE}: `papis -l papers config dirs`"
  echo -e "   ${COLOR_HIGHLIGHT}papis -l papers config dirs | cut -d \" -f2${STYLE_NONE}:" `papis -l papers config dirs | cut -d "\"" -f2`
  echo -e "   ${COLOR_HIGHLIGHT}\$PAPIS_DIR${STYLE_NONE}: $PAPIS_DIR"
  exit -3
fi

# Add bibtex to papis
if [ -z "$REF" ]; then
  papis add --batch --from bibtex "$BIB"
else

  # Check if ref does not exist
  if [ -d "${PAPIS_DIR}/${REF}" ]; then
    # TODO: Ask user if the reference should be replaced.
    echo -e "Reference ${COLOR_HIGHLIGHT}${TEXT_BOLD}$REF${STYLE_NONE} already exists in the database."
    exit 0
  fi

  # Add to papis under REF keyword
  papis add --batch --from bibtex "$BIB" --folder-name "$REF"

  # Update ref field to REF keyword (force update of `ref`)
  papis update --force --doc-folder "${PAPIS_DIR}/${REF}" -s ref "$REF"

  # Add pdf file
  if [ ! -z "$PDF" ]; then papis addto --doc-folder "${PAPIS_DIR}/${REF}" --copy-pdf -f "$PDF"; fi
fi

# Update item parameters
if [ ! -z "$ADDENDUM" ]; then papis update --doc-folder "${PAPIS_DIR}/${REF}" -s addendum "$ADDENDUM"; fi
if [ ! -z "$KEYWORDS" ]; then papis update --doc-folder "${PAPIS_DIR}/${REF}" -s keywords "$KEYWORDS"; fi

## #{ Postprocess output yaml file

if [ ! -z "$REF" ] && [ -d "$PAPIS_DIR/$REF" ]; then

    FILE="$PAPIS_DIR"/"$REF"/info.yaml
    echo -e "Processing fields in file: $PAPIS_DIR/${COLOR_HIGHLIGHT}$REF${STYLE_NONE}/info.yaml"

    # Move ref and addendum up
    $VIM_BIN $HEADLESS -nEs -c '%g/addendum:/norm ddggP' -c "wqa" -- "$FILE"
    $VIM_BIN $HEADLESS -nEs -c '%g/ref:/norm ddggP' -c "wqa" -- "$FILE"

fi

## #}
