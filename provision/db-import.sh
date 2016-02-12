#!/bin/bash

# Imports *.sql files from ../data directory

BACKUP_FILES=/vagrant/data/*.sql
MYSQL_IMPORT_HASH=/mysql-import-hash

run_data_import()
{
	# import *.sql files if any to our newly created database
	files=$(ls $BACKUP_FILES 2> /dev/null | wc -l)
	if [ **"$files" != "0"** ];
	then
		if [ ! -f $MYSQL_IMPORT_HASH ]; then
			touch $MYSQL_IMPORT_HASH
		fi

		OLD_HASH=$(cat $MYSQL_IMPORT_HASH)
		NEW_HASH=$(cat $BACKUP_FILES | md5sum | awk '{print $1}')

		if [ "$OLD_HASH" == "$NEW_HASH" ];
		then
			printf "\nBackup files have not changed since the last import. Skipping database import...\n"
		else
			printf "\nDropping existing databases...\n"
			echo "DROP DATABASE IF EXISTS sensor-database;" | mysql -u root -pblank
			echo "CREATE DATABASE sensor-database;" | mysql -u root -pblank
			printf "\nRestoring database from SQL dump. It may take a while...\n"
			cat $BACKUP_FILES | mysql -u root -pblank sensor-database
			printf "Done.\n"
			echo $NEW_HASH > $MYSQL_IMPORT_HASH
		fi
	else
		printf "\nNo SQL files were detected, skipping DB import...\n"
	fi
}

run_data_import
