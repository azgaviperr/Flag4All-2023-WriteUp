# BASH_HELL_cat

# Énoncé : 

    Répondez aux 10 questions de notre serveur bashcat pour récupérer le FLAG.
    Vous avez 1seconde/question.
  
    Le seul problème pour vous est que ce serveur est caché par une gateway BASH nomé : bash-hell.flag4all.sh.

    Information de connection à la gateway : 
      ssh -p 666 the_gate@bash-hell.flag4all.sh
      pass: iop
    Information  de connection au bashcat :
      nc bashcat 666

    Montrez nous votre maitrise en BASH ! Bonne change !

    Format du FLAG : 
        FLAG{PenTh1um2_1s_4_devil}


# Analyse :

Lorsque l'on se connecte sur le serveur bashcat celui si nous demande une question.
Après analyse on peut voir qu'il y a deux type de question : 

    Quelle est la valeur du champ numéro XXX sur la ligne qui a comme premier champ 'un mot' ?

    Combien de caractères contient le champ numéro XXX sur la ligne qui a comme premier champ 'un mot'?

Et quand on se connecte a bash-hell.flag4all.sh il y a un fichier list.cvs dans notre home directory avec des données de ce style : 

```
"dream","familiar","bit","ability","neck"
"fact","tune","task","cover","tired"
"beyond","public","promised","journey","grow"
"cry","time","dog","chapter","torn"
"musical","test","fruit","mouse","fellow"
"laugh","improve","driving","thy","live"
"local","gulf","browserling","harbor","kind"
"everywhere","neighbor","clearly","became","browserling"
"voyage","soft","universe","die","toy"
"quick","using","official","substance","religious"
"minute","person","nobody","carefully","rice"
"voice","all","heading","any","who"
"explore","express","taken","widely","present"
"edge","solve","hunter","railroad","character"
"improve","draw","capital","season","material"
"sight","window","curious","tomorrow","smaller"
"capital","direct","mighty","underline","addition"
"just","whenever","partly","chamber","using"
"fully","found","late","taken","wall"
"deal","remove","from","lack","slight"
"steel","uncle","printed","hope","warm"
"original","attack","event","talk","metal"
```

Le but est donc de pouvoir faire un script qui se connecte a bashcat, et réponde aux questions.

## problématique :

D'après l'énoncé on nous dit : 
    
    Montrez nous votre maitrise en BASH ! Bonne change !

En regardant ce qu'on a dans bash-hell.flag4all.sh on découvre vite plusieurs choses : 

- seul bash est des programes basique sont présent : pas de python, pas de perl, de php, rien ... juste **bash**

- quand on se deco/reco on perd tout ce qu'on a fait voir on change d'utilisateur 

*info sur le serveur the gate, j'ai fais une prison qui quand on se log via ssh avec l'utilisateur the_gate on est automatiquement tranferé vers un autre utilisateur non utilisé. 
Et a chaque déco je supprime tous fichiers créés par cette utilisateur.*

## quoi faire ? 

La seul chose a faire est donc de créer un script bash qui se connecte via nc sur le serveur bashcat pour répondre au question.

## le script pour le faire : 

```
#!/bin/bash
SERVER='127.0.0.1'
PORT='666'
CHATLOG='log'
echo "" > $CHATLOG

f_decode() {
ask=$@
if [[ $(echo $ask | awk '{print $1}') = Combien ]] ; then
       field=$(echo $ask | sed -E "s/^.*éro (.) sur.*$/\1/")
       line=$(echo $ask | sed -E "s/^.* '([^']+).*$/\1/")
       grep '^"'"$line"'"' list.csv | awk -F'","' '{print $'"$field"'}' | tr -d '"' | tr -d "\n" | wc -c

elif [[ $(echo $ask | awk '{print $1}') = Quelle ]] ; then
       field=$(echo $ask | sed -E "s/^.*éro (.) sur.*$/\1/")
       line=$(echo $ask | sed -E "s/^.* '([^']+).*$/\1/")
       grep '^"'"$line"'"' list.csv | awk -F'","' '{print $'"$field"'}' | tr -d '"'
fi
}

input() {
       while true; do
       if tail -1 $CHATLOG | grep -qs 'FLAG' ; then
              break
       else
              f_decode $(tail -1 $CHATLOG )

       fi
       done
       }
start() {

              input | nc $SERVER $PORT 2> /dev/null > $CHATLOG;

}
start
flag=$(tail -1 $CHATLOG | sed -E 's/^.*(FLAG[^}]+\}).*$/\1/')
echo $flag
```


# FLAG :

    FLAG{B4sH_is_Your_FriEnd}

# Auteur : 

Penthium2