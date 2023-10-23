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