#!/bin/bash

mkdir /tmp/misc
instalooter user lisasophielaurent /tmp/misc
cd /tmp/misc

a=1; for file in *; do new=$(printf "%04d.jpg" "$a"); convert "$file" "$new"; let a=a+1; rm $file; done

for i in /tmp/misc/*.jpg ; do
  if [ "$(convert $i -format "%[colorspace]" info:)" == "Gray" ]; then
    rm "$i" 
  fi
done
