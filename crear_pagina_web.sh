#!/bin/bash
DEPT=$1
USER="user_$dept"

echo "Password para consultar el servidor LDAP"
USERUID=$(ldapsearch -x -D "uid=replica,dc=sergio,dc=gonzalonazareno,dc=org" -W uid=$USER|grep uidNumber|awk -F' ' '{ print $2 }')
if [$USERUID != "" ];
then
  LDAPUID=$(expr $USERUID + 1)
  mkdir /var/www/www/$DEPT
  chown $USERUID:apache /var/www/www/$DEPT
  chcon -t public_content_rw_t /var/www/www/$DEPT
else
  echo "El usuario $USER debe estar creado previamente en el servidor LDAP"
fi
