#!/usr/bin/env bash
# Creates the MySQL database of Notebook Manager when the image is built (see /infrastructure/api/restgym-mysql.sh)

source /infrastructure/api/restgym-mysql.sh

# The API connects as root with the password root123 (set in entrypoint.sh), and creates its table and its sample data
# itself when it starts (Hibernate, and InitiateDatabaseRecords in its code)
restgym_mysql_init <<SQL
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root123';
FLUSH PRIVILEGES;
CREATE DATABASE notebook_manager;
SQL
