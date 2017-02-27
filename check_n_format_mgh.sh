#!/bin/bash
#	Name of Script: check_n_format_mgh.sh
#    Purpose of Script: This script is designed to receive an input name of file or directory and convert the file or directory contents from
##	                windows to linux format.
#	 Author's Name: Maria G. Hinojosa
#	   Affiliation: TAMIU
#         Date Created: 02/25/17
#	 Date modified:  
#	   Usage notes: Follow instructions commented in script. 

read -p "Enter file name or directory to verify format; the file or directory will be converted to a linux format where applicable: " file_or_dir

file $file_or_dir > df_rep.txt
var_fd=$(ls $file_or_dir)

if grep -q "ASCII" df_rep.txt ; then
	if grep -q "CRLF" df_rep.txt; then
		dos2unix $file_or_dir
	else
		mac2unix $file_or_dir
	fi
else
	for i in "${var_fd[*]}"
	do
		cd $file_or_dir
		if grep -q "CRLF" $i ; then
			echo "Hi"
		else 
			mac2unix $i
		fi
	done
fi



# place ${var_fd[*]} in double quotes for it to work
	#for each item in the variable (array) var_fd do the following





##this does not work, directory still states it is a file
#if [ grep -i ASCII $file_or_dir' ]
#	echo it is a file"
#else 
#	echo it is a directory"
#fi
