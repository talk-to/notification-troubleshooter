if [ -z "$1" ]; then
  echo "Command line argument missing. Usage: ./utf-8-converter.sh <PATH_TO_DIRECTORY>"
  exit 1
fi

for entry in "$1"/*
do
  output="$(file --mime $entry)"
  from_encoding="$(echo $output | grep -o "charset=.*" | cut -c 9-)"
  if [[ ! $from_encoding == utf-8 ]]; then
    iconv -f "$from_encoding" -t utf-8 "$entry" > tmp 2> /dev/null
    if [ "$?" = "0" ]; then
      mv tmp "$entry"
    else 
      rm -f tmp
    fi
  fi
done
