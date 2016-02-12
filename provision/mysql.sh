#!/bin/sh
# Define variables
MYSQL_FLAG=/mysql-configured

# Initialize DB setup
#
if [ ! -f $MYSQL_FLAG ]; then
	# Install latest version of MySQL-server
	#
	DEBIAN_FRONTEND=noninteractive apt-get -y install mysql-client-5.6 mysql-server-5.6
	service mysql restart

	MYSQL_PASSWORD="blank"
	printf "mysql root password: $MYSQL_PASSWORD"
	echo $MYSQL_PASSWORD > /mysql-root-pw.txt
	mysqladmin -u root password $MYSQL_PASSWORD

	sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/my.cnf
	# Grants:
	echo "GRANT ALL ON *.* TO root@'%' IDENTIFIED BY 'blank' WITH GRANT OPTION;" | mysql -u root -pblank
	echo "GRANT ALL ON *.* TO root@localhost IDENTIFIED BY 'blank' WITH GRANT OPTION;" | mysql -u root -pblank
	# Create databases:
	# prod config
	echo "auto_increment_increment = 2" >> /etc/mysql/my.conf

	touch $MYSQL_FLAG
fi
