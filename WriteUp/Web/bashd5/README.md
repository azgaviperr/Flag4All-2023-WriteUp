# Bashd5



# Énoncé

    conectez vous au site web pour répondre à la question.

    Information de connection à la gateway : 
        ssh -p 666 bash-hell.flag4all.sh
        pass: iop
    Information  de connection au site web :
        http://webd5/

    Montrez nous votre maitrise en BASH et WEB ! Bonne change !

    Format du FLAG : 
        FLAG{PenTh1um2_1s_4_devil}


# WriteUp :

quand on se connection via curl le site dit : 

    <!DOCTYPE html>
    <html>
    <head>
        <title>Quiz MD5</title>
    </head>
    <body>
        <h1>Quiz MD5</h1>
        <form action="/check_answer" method="post">
            <div>quel est le nom du CTF en minuscule ?<p>donnez la réponse en md5</p></div>
            <input type="text" name="answer" placeholder="Réponse">
            <button type="submit">Vérifier</button>
        </form>
    </body>

Depuis bash-hell.flag4all.sh faire : 

     curl -X POST --data-binary "answer=$(printf flag4all | md5sum| awk '{print $1}')" "http://webd5/check_answer"

# FLAG :

    FLAG{curl_1s_ea5y}
# Auteur : 

Penthium2

