#!/usr/bin/env bash
# Starts Notebook Manager in RESTgym: see /infrastructure/api/restgym-api.sh

source /infrastructure/api/restgym-api.sh

# MySQL, with a new database at each start
service mysql start || restgym_fail "MySQL did not start."
restgym_wait_until MySQL mysqladmin ping -h localhost --silent

# Set the root password (MySQL 8.0 requires authentication), and create the database
mysql --user=root <<-EOSQL || restgym_fail "Could not set the password of MySQL."
    ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root123';
    FLUSH PRIVILEGES;
EOSQL
mysql --user=root --password=root123 <<-EOSQL || restgym_fail "Could not create the database."
    DROP DATABASE IF EXISTS notebook_manager;
    CREATE DATABASE notebook_manager;
EOSQL
if [ -f /api/database/schema.sql ]; then
    mysql --user=root --password=root123 notebook_manager < /api/database/schema.sql || restgym_fail "Could not create the schema."
fi
if [ -f /api/database/data.sql ]; then
    mysql --user=root --password=root123 notebook_manager < /api/database/data.sql || restgym_fail "Could not load the data."
fi

restgym_run_api 8080 \
    java -javaagent:/infrastructure/jacoco/org.jacoco.agent-0.8.7-runtime.jar=includes=*,output=tcpserver,port=12345,address=* \
        -Dfile.encoding=UTF-8 \
        -Dserver.port=8080 \
        "-Dspring.datasource.url=jdbc:mysql://localhost:3306/notebook_manager?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true" \
        -Dspring.datasource.username=root \
        -Dspring.datasource.password=root123 \
        -Dspring.jpa.hibernate.ddl-auto=none \
        -jar /api/notebookmanager.jar
