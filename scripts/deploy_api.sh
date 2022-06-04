#!/bin/bash
#
# Nginx - new server block for deploying Airgigs Api application
# sed -i -e 's/\r$//' /vagrant/bash-scripts/scripts/deploy_api.sh
# Functions
ok() { echo -e '\e[32m'$1'\e[m'; } # Green
die() { echo -e '\e[1;31m'$1'\e[m'; exit 1; }
println() {
echo "---------------------------------"
echo -e '\e[32m'$1'\e[m';
echo "---------------------------------"
} # Info

# Variables
SUPERVISOR_DIR='/etc/supervisor/conf.d'
WEB_DIR='/home/vagrant/Airgigs-APi'
WEB_USER='www-data'
USER='ubuntu'
NVM_VERSION='16'

PHP_VERSION='8.1'
PHP_INI_PATH="/etc/php/${PHP_VERSION}/fpm/php.ini"
PHP_XDEBUG_VERSION_NAME='xdebug-3.1.4'

# Sanity check
[ $(id -g) != "0" ] && die "Script must be run as root."


println "Do you want to install PHP xdebug (y/n)?";
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then # this grammar (the #[] operator) means that the variable $answer where any Y or y in 1st position will be dropped if they exist.
sudo apt-get -y install php$PHP_VERSION-dev

wget https://xdebug.org/files/$PHP_XDEBUG_VERSION_NAME.tgz
sudo tar -xzf $PHP_XDEBUG_VERSION_NAME.tgz
cd $PHP_XDEBUG_VERSION_NAME
phpize #check it is install or not
./configure --enable-xdebug
make
make install

cat << EOF >> $PHP_INI_PATH
[xdebug]
zend_extension= xdebug.so
xdebug.client_port=9003
xdebug.mode=debug
xdebug.start_with_request=yes
xdebug.mode=debug
xdebug.discover_client_host = on
xdebug.idekey = "AIRGIGS_LOCAL_API"
EOF

ok "PHP xdebug is enabled!!";
fi


println "Do you want to enable websocket in supervisor (y/n)?";
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then

# Update application .env file for pusher
sed -i "/BROADCAST_DRIVER/c\BROADCAST_DRIVER=pusher" $WEB_DIR/.env
sed -i "/WEBSOCKETS_SSL_LOCAL_CERT/c\WEBSOCKETS_SSL_LOCAL_CERT='/etc/ssl/certs/api.local.com.crt'" $WEB_DIR/.env
sed -i "/WEBSOCKETS_SSL_LOCAL_PK/c\WEBSOCKETS_SSL_LOCAL_PK='/etc/ssl/certs/api.local.com.key'" $WEB_DIR/.env

# Create supervisord ionic.conf
tee $SUPERVISOR_DIR/websockets-worker.conf > /dev/null <<EOF
[program:websockets-worker]
process_name=%(program_name)s_%(process_num)02d
command=php $WEB_DIR/artisan websockets:serve
autostart=true
autorestart=true
user=root
numprocs=1
stderr_logfile=/var/log/supervisorderr.log
stdout_logfile=/var/log/supervisord.log

EOF

supervisorctl reread && supervisorctl update && supervisorctl restart all

ok "Websocket has been enabled!!"
fi

sudo /etc/init.d/php8.1-fpm restart
sudo service nginx restart

ok "Airgigs Api Setup is completed !!"
