#!/bin/bash
DEPT=$1
USER="user_$DEPT"

# ldap base dc=sergio,dc=gonzalonazareno,dc=org
# ldapserver ldap://mickey.ferrete.gonzalonazareno.org

echo "Busqueda anónima comprobando si existe el usuario"
USERUID=$(ldapsearch -x uid=$USER |grep uidNumber|awk -F' ' '{ print $2 }')
if [ "$USERUID" != "" ];
then
  mkdir /var/www/www/$DEPT
  chown $USERUID:3000 /var/www/www/$DEPT
  chcon -t public_content_rw_t /var/www/www/$DEPT
  echo "Usuario: $USER Password: asdasd"
else
  echo "Usuario no existe, se procede a crearlo, Consultando un uid que no exista"
  USERUID=$(ldapsearch -x uidNumber|grep uidNumber|awk -F' ' '{ print $2 }'|sort -r|awk NR==2)
  USERUID=$(expr $USERUID + 1)
  echo "dn: uid=$USER,ou=People,dc=sergio,dc=gonzalonazareno,dc=org
objectClass: top
objectClass: posixAccount
objectClass: inetOrgPerson
objectClass: person
cn: $USER
uid: $USER
uidNumber: $USERUID
gidNumber: 3000
homeDirectory: /var/www/www/$DEPT
userPassword: {SHA}hRNsecv5/ja7nQXQY5xwwmXBjTc=
loginShell: /bin/bash
sn: $USER
mail: $USER@localhost
givenName: $USER" > temp.ldif
  echo "Password de administración del servidor LDAP"
  ldapadd -x -D "cn=admin,dc=sergio,dc=gonzalonazareno,dc=org" -W -f temp.ldif
  rm temp.ldif
  ./crear_pagina_web.sh $DEPT
fi
