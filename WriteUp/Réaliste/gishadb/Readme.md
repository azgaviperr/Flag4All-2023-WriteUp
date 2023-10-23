# gishadb

*concaténation de git ssh à DataBase*

# Énoncé : 

    Ce serveur écoute sur 2 ports ! 443 et 222.
    Trouvez un moyen d'obtenir le flag.
    
    https://gishadb.flag4all.sh

# Analyse :

Quand on se connecte sur le site web on a ce code html : 

    <H1>Je suis un maitre du PHP et SQL</h1>
    <p>dans ma table <b>HAND</b></p>";
    <p> voici le pouce de penthium2 et son id : 1<p>
    <h2> mais quel est la valeur de l'id 3 ??</h2>

Nous pouvons donc en déduire qu'il y a du SQL dans l'air..

# Résolution

Nous somme dans un chall où les orga autorise le fuzzing, et après un petit fuzzing on découvre un répertoire .git

On récupère celui-ci et après une analyse des log et commit.

On a donc comme information utils ::

- login ssh (gishadb pass iop)
- config.php : $cnx = new PDO('mysql:host=127.0.0.1;dbname=app;charset=utf8', 'app', 'db_Super_P4$$');

# le rabbit hole :

Toute personne tentant de se connecté en ssh sur le port 222 avec :

    ssh -p 222 gishadb@gishadb.flag4all.sh

Tombait dans un shell MATRIX sans possibilité de faire ctrl-C

Voici en cadeau le code du shell de l'utilisateur : 

```
#!/bin/bash
trap '' INT
while true; 
       do printf "\e[32m%X\e[0m" $((RANDOM%2)); 
             for ((i=0; i<$((RANDOM%128)); i++)) 
                   do printf " "; 
                   done; 
       done;
exit
```
Ce script était le shell de l'utilisateur stocker dans /bin/troll

# La réflection final :

Donc nous avons a disposition :

- un login ssh ( mais qui tombe dans un troll)
- un login sql et le nom d'une base de donnée.

## Le final :

Il est possible de faire du port forwarding ( https://podalirius.net/en/articles/ssh-port-forwarding/ , merci maitre podalirius tu es l'inspiration de tant de chose).

- Sur une console on fait : 

    ```
    ssh :  ssh -N -p 666 -L 6666:127.0.0.1:3306 gishadb@192.168.124.1
    ```

- Sur une autre console on fait après connection :

    ```mysql -P 6666 -u app -p

    mysql>use app;
    mysql>select finger from hand where id=3 ;
    +-----------------------------+
    | finger                      |
    +-----------------------------+
    | FLAG{TAK3_Care_Of_SSH_POWA} |
    +-----------------------------+
    ```

# FLAG :

    FLAG{TAK3_Care_Of_SSH_POWA}

# Auteur : 

Penthium2