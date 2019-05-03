#!/bin/bash

# example :
#
#[ "$architecture" == "amd64" ] && image=portainer/portainer:1.14.0
#[ "$architecture" == "i386" ]  && image=portainer/portainer:linux-386-1.14.0
#[ "$architecture" == "armhf" ] && image=portainer/portainer:linux-arm-1.14.0
#[ -z $image ] && ynh_die "Sorry, your $architecture architecture is not supported ..."
#

sudo docker run --rm guacamole/guacamole /opt/guacamole/bin/initdb.sh --mysql > guac_initdb.sql

# TODO: use app name
# TODO: pass mysql password here
mysql -uguacamole -p02gS1xWXcUqJz3uA guacamole < guac_initdb.sql

options="-p $port:8080 -v /var/run/mysqld/mysqld.sock:/var/run/mysqld/mysqld.sock"

docker run --name apple-guacd --restart always -d guacamole/guacd 1>&2

docker run --name apple-guacamole --restart always \
    --link apple-guacd:guacd        \
    $options \
    -e MYSQL_HOSTNAME=localhost \
    -e MYSQL_DATABASE=guacamole \
    -e MYSQL_USER=guacamole \
    -e MYSQL_PASSWORD=02gS1xWXcUqJz3uA \
    -d guacamole/guacamole 1>&2

echo $?
