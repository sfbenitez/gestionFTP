#!/bin/bash
DEPT=$1
USER="user_$DEPT"

echo "Password para consultar el servidor LDAP"
USERUID=$(ldapsearch -x -D "uid=replica,dc=sergio,dc=gonzalonazareno,dc=org" -W -b "dc=sergio,dc=gonzalonazareno,dc=org" uid=$USER -h mickey-int|grep uidNumber|awk -F' ' '{ print $2 }')
if [ "$USERUID" != "" ];
then
  LDAPUID=$(expr $USERUID + 1)
  mkdir /var/www/www/$DEPT
  chown $USERUID:apache /var/www/www/$USER
  chcon -t public_content_rw_t /var/www/www/$USER
else
  echo "El usuario $USER debe estar creado previamente en el servidor LDAP"
fi
