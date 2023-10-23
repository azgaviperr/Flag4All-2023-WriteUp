#!/bin/bash
#echo 'FLAG{B4sE_Hide_Fl4g}' | perl -lpe '$_=unpack"B*"'
FLAGBIN=0100011001001100010000010100011101111011010000100011010001110011010001010101111101001000011010010110010001100101010111110100011001101100001101000110011101111101
fic=$1
rm More_Base.txt
cat $1 | while read line ; do
	encodage=$(printf "$line" | base64)
	#debug :
	pad=$(echo "$encodage" | sed -nE 's/^[^=]+(=+)$/\1/p')
	case $pad in
		=)
			encodage=$(echo "$encodage" | sed -E 's/=//g')
			bin_orig=$(echo "$encodage" |perl -lpe '$_=unpack"B*"')
			bin_new=$( echo $bin_orig |sed -E 's/^(.+)..$/\1/')$(echo "${FLAGBIN}" |sed -E 's/^(..).*$/\1/')
			FLAGBIN=$(echo "$FLAGBIN" | sed -E 's/^..(.*)/\1/')
			new_encode="$(echo "$bin_new" | perl -lpe '$_=pack"B*",$_')="
			;;
		==)
			encodage=$(echo "$encodage" | sed -E 's/=//g')
			bin_orig=$(echo "$encodage" |perl -lpe '$_=unpack"B*"')
			bin_new=$( echo $bin_orig |sed -E 's/^(.+)....$/\1/')$(echo "${FLAGBIN}" |sed -E 's/^(....).*$/\1/')
			FLAGBIN=$(echo "$FLAGBIN" | sed -E 's/^....(.*)/\1/')
			new_encode="$(echo "$bin_new" | perl -lpe '$_=pack"B*",$_')=="
			;;
		"")
			new_encode="$encodage"
	esac
	echo "$new_encode" >> More_Base.txt


done
	
# echo AB | perl -lpe '$_=unpack"B*"'
#0100000101000010
# echo 0100000101000010 | perl -lpe '$_=pack"B*",$_'
#AB
