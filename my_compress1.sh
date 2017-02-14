#!/bin/bash

echo -n "Enter file name: " 
read file
echo "Type 'z' to compress with gzip, type 'j' to compress with bzip2: "
read type

if [ $type = z ] ; then
	gzip $file | tar -cvf $file ; echo "file gzipped successful"
else
	bzip2 $file | tar -cvf $file ; echo "file bzipped2 successful" 
fi
