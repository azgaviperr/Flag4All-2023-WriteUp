# BASH_WEBcook

## Énoncé :

    Connectez vous depuis la gateway au site web pour répondre à la question.

    Information de connection à la gateway : 
      ssh -p 666 the_gate@bash-hell.flag4all.sh
      pass: iop
    Information  de connection au site web :
      http://webcook/

    Montrez nous votre maîtrise en BASH et WEB !
    Format du FLAG : 
        FLAG{PenTh1um2_1s_4_devil}

# WriteUp

Quand on se connection via curl on nous dit : 

  ```
  <!DOCTYPE html>
  <html>
  <head>
      <title>Quiz cook</title>
  </head>
  <body>
      <h1>Quiz cook</h1>
      <form action="/check_answer" method="post">
          <div>quel est le nom de l&#39;asso en minuscule qui organise ce CTF ?<p>donnez la réponse en md5</p></div>
          <input type="text" name="answer" placeholder="Réponse">
          <button type="submit">Vérifier</button><br>
          <p>Vous avez 2sec</p>
      </form>
  </body>
  ``````
Depuis bash-hell.flag4all.sh faire : 

     curl -c /tmp/test http://webcook ; curl -X POST --data-binary "answer=$(printf bzhack | md5sum| awk '{print $1}')" "http://webcook/check_answer" --cookie $(cat /tmp/test | sed -n '$p' | awk '{print $6 "=" $7}')
    
# FLAG

    FLAG{curl_Lov3_C0Ok1eS}


# Auteur : 

Penthium2
