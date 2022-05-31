#!/bin/bash
#
# Apache - new server block for deploying Airgigs applications
# sed -i -e 's/\r$//' /vagrant/bash-scripts/scripts/deploy.sh
# Functions
ok() { echo -e '\e[32m'$1'\e[m'; } # Green
die() { echo -e '\e[1;31m'$1'\e[m'; exit 1; }
println() { 
echo "---------------------------------"
echo -e '\e[32m'$1'\e[m';
echo "---------------------------------"
} # Info

# Variables
APACHE_AVAILABLE_VHOSTS='/etc/apache2/sites-available'
APACHE_ENABLED_VHOSTS='/etc/apache2/sites-enabled'

SITE_DEV3_NAME='airgigs'
SITE_LEGACY_ADMIN_NAME='legacy-dashboard'
SITE_LEARN_NAME='learn-airgigs'

DEV_WEB_DIR='/vagrant/dev3/dev3-airgigs/src'
LEGACY_DIR='/vagrant/legacy-dashboard/src'
LESSON_DIR='/vagrant/micro-lessons'

DATABASE_BACKUP_DIR='/vagrant/Setup/database'
dev3_dbname='airgigs_staging'
dev3_test_dbname='airgigs_staging_test'
lesson_dbname='wp_learnstageair'

SUPERVISOR_DIR='/etc/supervisor/conf.d'
APP_ORIGINAL_DIR='/vagrant/airgigsapp'
APP_DIR='/home/airgigsapp'

WEB_USER='www-data'
USER='ubuntu'
NVM_VERSION='16'

PHP_VERSION='8.1'
PHP_INI_PATH="/etc/php/${PHP_VERSION}/apache2/php.ini"
PHP_XDEBUG_VERSION_NAME='xdebug-3.1.4'

# Sanity check
[ $(id -g) != "0" ] && die "Script must be run as root."

println "Updating the system"
sudo apt -y update
ok "System is updated!!";


println "Installing apache2"
sudo apt-get -y install apache2
sudo a2enmod ssl && a2enmod rewrite && a2enmod expires && a2enmod deflate && a2enmod headers
ok "Apache2 install completed!!";


println "Installing PHP and it's dependable library"
sudo apt -y install software-properties-common && sudo add-apt-repository ppa:ondrej/php -y
sudo apt -y update
sudo apt-get -y install php$PHP_VERSION
sudo apt-get -y install php$PHP_VERSION-cli php$PHP_VERSION-common php$PHP_VERSION-mysql php$PHP_VERSION-zip php$PHP_VERSION-gd php$PHP_VERSION-mbstring php$PHP_VERSION-curl php$PHP_VERSION-xml php$PHP_VERSION-bcmath
ok "PHP install completed!!";


println "Installing composer"
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer
ok "Composer install completed!!";


println "Updating the PHP ini configuration"
sed -i '/;extension=openssl/c\extension=openssl' $PHP_INI_PATH
sed -i '/upload_max_filesize/c\upload_max_filesize = 512M' $PHP_INI_PATH
sed -i '/post_max_size/c\post_max_size = 256M' $PHP_INI_PATH
sed -i '/max_file_uploads/c\max_file_uploads = 20' $PHP_INI_PATH
ok "PHP ini update completed!!";


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
xdebug.idekey = "AIRGIGS_LOCAL"
EOF
ok "PHP ini update completed!!";
fi


println "Do you want to install MYSQL (y/n)?";
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
# Install MYSQL 5.7
wget https://dev.mysql.com/get/mysql-apt-config_0.8.12-1_all.deb
sudo apt install ./mysql-apt-config_0.8.12-1_all.deb
sudo apt -y update
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 467B942D3A79BD29
sudo apt -y install -f mysql-client=5.7* mysql-community-server=5.7* mysql-server=5.7*

println "Updating MYSQL configuration...";
cat << EOF >> /etc/mysql/my.cnf
[mysqld]
sql_mode=ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION

[mysqldump]
column-statistics=0
EOF

sed -i '/^bind-address/c\bind-address = 0.0.0.0' /etc/mysql/mysql.conf.d/mysqld.cnf
sed -i '/^mysqlx-bind-address/c\mysqlx-bind-address = 0.0.0.0' /etc/mysql/mysql.conf.d/mysqld.cnf
ok "MYSQL configuration completed!!"

println "Updating MYSQL configuration...";
echo "Please enter root user MySQL password! Note: password will be hidden when typing"
read -s rootpasswd

echo "Enter database user!"
read username

echo "Enter the PASSWORD for database user! Note: password will be hidden when typing"
read -s userpass

echo "Creating new user..."
mysql -uroot -p${rootpasswd} -e "CREATE USER '${username}'@'%' IDENTIFIED BY '${userpass}';"
ok "User successfully created!"

echo "Updating ${username} user password..."
mysql -uroot -p${rootpasswd} -e "ALTER USER ${username}@'localhost' IDENTIFIED WITH mysql_native_password BY '${userpass}';"
ok "User password successfully updated!"

echo "Granting ALL privileges for all database to ${username}!"
mysql -uroot -p${rootpasswd} -e "GRANT ALL PRIVILEGES ON *.* TO '${username}'@'%';"
mysql -uroot -p${rootpasswd} -e "FLUSH PRIVILEGES;"
ok "User permission successfully granted!"

echo "Creating new MySQL database..."
mysql -uroot -p${rootpasswd} -e "CREATE DATABASE IF NOT EXISTS ${dev3_dbname} DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci";
mysql -uroot -p${rootpasswd} -e "CREATE DATABASE IF NOT EXISTS ${dev3_test_dbname} DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci";
mysql -uroot -p${rootpasswd} -e "CREATE DATABASE IF NOT EXISTS ${lesson_dbname} DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci";
ok "Database successfully created!"

echo "Importing database for dev3"
mysql -uroot -p${rootpasswd} $dev3_dbname < $DATABASE_BACKUP_DIR/$dev3_dbname.sql
ok "Dev3 database import completed!!"

echo "Importing database for dev3 test"
#mysql -uroot -p${rootpasswd} $dev3_test_dbname < $DATABASE_BACKUP_DIR/$dev3_test_dbname.sql
ok "Dev3 test database import completed!!"

echo "Importing database for lesson"
#mysql -uroot -p${rootpasswd} $lesson_dbname < $DATABASE_BACKUP_DIR/$lesson_dbname.sql
ok "Lesson database import completed!!"
fi

println "Do you want to configure airgigs applications (y/n)?";
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
# Clearing apache config
rm -rf $APACHE_ENABLED_VHOSTS/*

# Adding dev3 apache config
tee $APACHE_AVAILABLE_VHOSTS/$SITE_DEV3_NAME.conf > /dev/null <<EOF
<VirtualHost *:443>
       ErrorDocument 500 $DEV_WEB_DIR/error.html
       ServerAdmin webmaster@localhost
       ServerName airgigs.local
       DocumentRoot $DEV_WEB_DIR

       <Directory $DEV_WEB_DIR>
           Options +FollowSymLinks +MultiViews
           AllowOverride All
           Require all granted
       </Directory>
       ErrorLog ${APACHE_LOG_DIR}/airgigs-error.log
       CustomLog ${APACHE_LOG_DIR}/airgigs-access.log combined

       SSLEngine on
       SSLCertificateFile $DEV_WEB_DIR/.certificates/api.local.com.crt
       SSLCertificateKeyFile $DEV_WEB_DIR/.certificates/api.local.com.key
</VirtualHost>

<VirtualHost *:80>
       ErrorDocument 500 $DEV_WEB_DIR/error.html
       ServerAdmin webmaster@localhost
       ServerName airgigs.local
       DocumentRoot $DEV_WEB_DIR

       <Directory $DEV_WEB_DIR>
           Options +FollowSymLinks +MultiViews
           AllowOverride All
           Require all granted
       </Directory>
       ErrorLog ${APACHE_LOG_DIR}/airgigs-error.log
       CustomLog ${APACHE_LOG_DIR}/airgigs-access.log combined

       SSLEngine off
       SSLCertificateFile $DEV_WEB_DIR/.certificates/api.local.com.crt
       SSLCertificateKeyFile $DEV_WEB_DIR/.certificates/api.local.com.key
</VirtualHost>
EOF

# Adding legacy-admin apache config
tee $APACHE_AVAILABLE_VHOSTS/$SITE_LEGACY_ADMIN_NAME.conf > /dev/null <<EOF
<VirtualHost *:80>
       ErrorDocument 500 $LEGACY_DIR/error.html
       ServerAdmin webmaster@localhost
       ServerName legacy-dashboard.local
       DocumentRoot $LEGACY_DIR

       <Directory $LEGACY_DIR>
           Options +FollowSymLinks +MultiViews
           AllowOverride All
           Require all granted
       </Directory>
       ErrorLog ${APACHE_LOG_DIR}/legacy-dashboard-error.log
       CustomLog ${APACHE_LOG_DIR}/legacy-dashboard-access.log combined
</VirtualHost>
EOF

# Adding learn airgigs apache config
tee $APACHE_AVAILABLE_VHOSTS/$SITE_LEARN_NAME.conf > /dev/null <<EOF
<VirtualHost *:80>
       ServerAdmin webmaster@localhost
       ServerName learn.airgigs.local
       DocumentRoot $LESSON_DIR

       <Directory $LESSON_DIR>
           Options +FollowSymLinks +MultiViews
           AllowOverride All
           Require all granted
       </Directory>
       ErrorLog ${APACHE_LOG_DIR}/learn-airgigs-error.log
       CustomLog ${APACHE_LOG_DIR}/learn-airgigs-access.log combined
</VirtualHost>
EOF

# Enable site by creating symbolic link
ln -s $APACHE_AVAILABLE_VHOSTS/$SITE_DEV3_NAME.conf $APACHE_ENABLED_VHOSTS/$SITE_DEV3_NAME.conf
ln -s $APACHE_AVAILABLE_VHOSTS/$SITE_LEGACY_ADMIN_NAME.conf $APACHE_ENABLED_VHOSTS/$SITE_LEGACY_ADMIN_NAME.conf
ln -s $APACHE_AVAILABLE_VHOSTS/$SITE_LEARN_NAME.conf $APACHE_ENABLED_VHOSTS/$SITE_LEARN_NAME.conf
ok "Apache configuration completed!!"
fi


println "Do you want to install Airgigs Web App (y/n)?";
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
cd /home
echo "Installing Airgigs Web App dependencies"
sudo apt -y install nodejs
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash
source ~/.bashrc
#nvm list-remote
nvm install 16
nvm use 16

# sudo npm install -g cordova
npm i -g @ionic/cli

mkdir $APP_DIR
chmod 777 -R $APP_DIR
cd $APP_DIR/

ln -s $APP_ORIGINAL_DIR/* ./
ln -s $APP_ORIGINAL_DIR/.env ./

echo "Building Airgigs Web App"
npm install
npm run build
ionic cap sync

rm -rf $APP_ORIGINAL_DIR/dist
rm -rf $APP_ORIGINAL_DIR/node_modules

cp -L -R ./node_modules $APP_ORIGINAL_DIR/
cp -L -R ./dist $APP_ORIGINAL_DIR/

echo "Installing supervisor for Airgigs Web App"
sudo apt -y install supervisor

# Create supervisord airigs-app.conf
tee $SUPERVISOR_DIR/airigs-app.conf > /dev/null <<EOF
[program:ionic]
command=npm run serve -- --port 8100
directory=$APP_DIR
autostart=true
autorestart=true
startretries=3
stderr_logfile=/var/log/supervisor/airgigsapp-error.log
stdout_logfile=/var/log/supervisor/airgigsapp-out.log
EOF

supervisorctl reread && supervisorctl update && supervisorctl restart all
ok "Airgigs Web App setup completed!!"
fi

println "Do you want to install PHPMYADMIN (y/n)?";
read answer

if [ "$answer" != "${answer#[Yy]}" ] ;then
sudo apt-get -y install zip unzip php-zip
# After downloading extract archive and move to the proper location
wget https://files.phpmyadmin.net/phpMyAdmin/5.1.1/phpMyAdmin-5.1.1-all-languages.zip
unzip phpMyAdmin-5.1.1-all-languages.zip
mv phpMyAdmin-5.1.1-all-languages /usr/share/phpmyadmin

#create tmp directory and set the proper permissions.
mkdir /usr/share/phpmyadmin/tmp
chown -R www-data:www-data /usr/share/phpmyadmin
chmod 777 /usr/share/phpmyadmin/tmp

# Adding configuration for adding it with apache
cat << EOF >> /etc/apache2/conf-available/phpmyadmin.conf
Alias /phpmyadmin /usr/share/phpmyadmin
Alias /phpMyAdmin /usr/share/phpmyadmin

<Directory /usr/share/phpmyadmin/>
AddDefaultCharset UTF-8
<IfModule mod_authz_core.c>
  <RequireAny>
  Require all granted
  </RequireAny>
</IfModule>
</Directory>

<Directory /usr/share/phpmyadmin/setup/>
<IfModule mod_authz_core.c>
  <RequireAny>
  Require all granted
  </RequireAny>
</IfModule>
</Directory>
EOF

sudo a2enconf phpmyadmin;
ok "PHPADMIN setup completed!!"
fi


sudo service mysql restart
sudo systemctl restart apache2

ok "Airgigs Setup completed !!"
