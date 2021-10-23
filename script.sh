

PORT=
HOST=
USERNAME=

STD=/etc/apache2/conf.d/userdata/stf/2_4/${USERNAME}/${HOST}
SSL=/etc/apache2/conf.d/userdata/ssl/2_4/${USERNAME}/${HOST}

mkdir -p $STD
mkdir -p $SSL

CONFIG="
ProxyPreserveHost off
RewriteEngine On
RewriteCond %{HTTPS} !=on
RewriteRule ^/?(.*) https://%{SERVER_NAME}/\$1 [R,L]

RewriteCond %{HTTP:Upgrade} =websocket [NC]
RewriteRule /(.*)           ws://localhost:${PORT}/\$1 [P,L]
RewriteCond %{HTTP:Upgrade} !=websocket [NC]
RewriteRule /(.*)           http://localhost:${PORT}/\$1 [P,L]"

echo "$CONFIG" >>$STD/node.conf
echo "$CONFIG" >>$SSL/node.conf

#rebuild conf file
/scripts/rebuildhttpdconf

#restart apache server
service httpd restart
