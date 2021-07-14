#!/bin/bash

I=`dpkg -l | grep "unrar"`
if [ -n "$I" ]
then
   echo unrar installed
else
   sudo apt-get install unrar -y
fi

start() {
  local fullname="$1"
  local filename=`basename "$1"`
  local fileext="${filename##*.}"
  if  [[ $fileext = "zip" || $fileext = "rar" ]]
    then
	unrar x "$fullname" "${fullname%/*}"
	rm "$fullname"
  fi
}

scan() {
  local x;
  for e in "$1"/*; do
    x=${e##*/}
    if [ -d "$e" -a ! -L "$e" ]
    then
      scan "$e"
    else
      start "$e"
    fi
  done
}

[ $# -eq 0 ] && dir=`pwd` || dir=$@


scan "$dir"
