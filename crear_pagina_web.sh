#!/bin/bash
DEPT=$1
USER="user_$DEPT"

echo "Password para consultar el servidor LDAP"
USERUID=$(ldapsearch -x -D "uid=replica,dc=sergio,dc=gonzalonazareno,dc=org" -W -b "dc=sergio,dc=gonzalonazareno,dc=org" uid=$USER -h mickey-int|grep uidNumber|awk -F' ' '{ print $2 }')
if [ "$USERUID" != "" ];
then
  mkdir /var/www/www/$USER
  chown $USERUID:apache /var/www/www/$USER
  chcon -t public_content_rw_t /var/www/www/$USER
else
  echo "dn: uid=$USER,ou=People,dc=sergio,dc=gonzalonazareno,dc=org
        objectClass: top
        objectClass: posixAccount
        objectClass: inetOrgPerson
        objectClass: person
        cn: $USER
        uid: $USER
        uidNumber: $LDAPUID
        gidNumber: 2000
        homeDirectory: /var/www/$DEPT
        userPassword: {SHA}hRNsecv5/ja7nQXQY5xwwmXBjTc=
        loginShell: /bin/bash
        sn: $USER
        mail: $USER@gmail.com
        givenName: $USER" > temp.ldif
        echo "Password de administración del servidor LDAP"
        ldapadd x -D "cn=admin,dc=sergio,dc=gonzalonazareno,dc=org" -W -f temp.ldif
        rm temp.ldif
        ./crear_pagina_web.sh $DEPT
fi
