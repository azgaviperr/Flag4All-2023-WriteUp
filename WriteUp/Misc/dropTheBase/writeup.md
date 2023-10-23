# DROP THE BASE 

## Énoncé :

  Nous avons un gros problème avec notre application maison de conversion en base64. 
  En effet celle-ci a été modifiée par un stagaire, et depuis les résultats sont anormaux.
  Nous le soupçonnons d'exfiltrer des données..

  Analyser ces deux fichiers : 
  - Drop_The_Base.txt : Fichier originale 
  - More_Base.txt : Fichier encodé

  Trouvez ce qui ne va pas et trouver le flag.. 
  exemple : FLAG{4ce_0f_Ba55}

  Auteur : Penthium2 (BZHack)

## analyse :

on a deux fichier : 

	- un en clair
	- l'autre en base Base64



### Idée : 
- traduire la base64 corumpu :

	Faire la diff avec le clair, il y a des bug

- traduire le clair en base64 propre

	Faire la diff avec le corompu les base sont pas identique :
	Les lignes inpactées ont toutes un = ou un ==

### piste

Il faut se renseigner sur comment cacher des données en base64 ou lire la RCF 

On découvre qu'on peut caché dans le pading !!

on parle de bit !

	transformation du clair > base64 > binaire
	transformation du coprompu > binaire

voir qu'il y a les fin de ligne pas pareil ( logique )

Sauf que c'est un stagiaire qui a fait le script et il à mal implémenté la technique. 
donc il faut  :

faire un scrip qui si ligne différente, faire une extraction :

	Si un =, alors 2 bit
	Si deux =, alors extraction de 4bit

faire un string qui contient les bits recupérer


FLAG  :

	FLAG{B4sE_Hide_Fl4g}

## exemple de script : 

```
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

```

ce script prend en entré le fichier avec la base et le fichier en clair

```
./"outils du challdecode.sh" More_Base.txt Drop_The_Base.txt 
```

# FLAG :

	FLAG{B4sE_Hide_Fl4g}