#/bin/bash
fic=$1
original=$2
	declare -i tab
	while read line ;do
		orig[$tab]=$(printf $line | base64)
		tab+=1
	done < <(cat $original)
	tab=0
	declare -i tab
	tab=0
	while read line ;do
                bug[$tab]=$line
		tab+=1
	done < <(cat $fic)
declare -i nb
nb=0
until [[ "${bug[$nb]}" = "" ]] ; do
	if [[ ${bug[$nb]} != ${orig[$nb]} ]] ; then
		pad=$(echo "${bug[$nb]}" | sed -nE 's/^[^=]+(=+)$/\1/p')
		case $pad in
			=)
				bugy[$nb]=$(printf "${bug[$nb]}" | sed -E 's/=//g')
				FLAG=$FLAG$(printf "${bugy[$nb]}" | perl -lpe '$_=unpack"B*"' | sed -E 's/^.*(..)$/\1/')
				nb+=1
				;;
			==)
				bugy[$nb]=$(printf "${bug[$nb]}" | sed -E 's/=//g')
				FLAG=$FLAG$(printf "${bugy[$nb]}" | perl -lpe '$_=unpack"B*"' | sed -E 's/^.*(....)$/\1/') 
				nb+=1
                                ;;
			"")
				nb+=1
				;;
		esac
	
	else
		nb+=1
	fi

done
echo $FLAG | perl -lpe '$_=pack"B*",$_'
