#!/usr/bin/env bash
# Creates the MySQL database of Notebook Manager when the image is built (see /infrastructure/api/restgym-mysql.sh)

source /infrastructure/api/restgym-mysql.sh

# The API connects as root with the password root123 (set in entrypoint.sh)
restgym_mysql_init <<SQL
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root123';
FLUSH PRIVILEGES;
CREATE DATABASE notebook_manager;
USE notebook_manager;
SOURCE /api/database/schema.sql;
SOURCE /api/database/data.sql;
SQL
