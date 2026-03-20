#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

DB_PASS="${db_password}"

apt-get update -y
apt-get install -y apache2 php php-mysql libapache2-mod-php wget unzip mariadb-server

systemctl enable apache2
systemctl start apache2
systemctl start mariadb

# MySQL setup
mysql -e "CREATE DATABASE wordpress;"
mysql -e "CREATE USER 'wpuser'@'localhost' IDENTIFIED BY '$${DB_PASS}';"
mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';"
mysql -e "FLUSH PRIVILEGES;"

cd /var/www/html
rm -rf index.html

wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
mv wordpress/* .
rm -rf wordpress latest.tar.gz

cp wp-config-sample.php wp-config.php

sed -i "s/database_name_here/wordpress/" wp-config.php
sed -i "s/username_here/wpuser/" wp-config.php
sed -i "s/password_here/$${DB_PASS}/" wp-config.php

chown -R www-data:www-data /var/www/html

systemctl restart apache2

# Create log file
touch /var/log/login_audit.log
chmod 666 /var/log/login_audit.log

cat <<'EOF' >> /etc/profile

# Log login
echo "$(whoami) LOGIN at $(date) from $(who am i | awk '{print $5}')" >> /var/log/login_audit.log

# Log logout using trap
trap 'echo "$(whoami) LOGOUT at $(date)" >> /var/log/login_audit.log' EXIT

EOF