#!/usr/bin/env bash
# Starts Notebook Manager in RESTgym: see /infrastructure/api/restgym-api.sh

source /infrastructure/api/restgym-api.sh
source /infrastructure/api/restgym-mysql.sh

# MySQL, with the database created when the image is built (init-mysql.sh)
restgym_start_mysql

restgym_run_api 8080 \
    java -javaagent:/infrastructure/jacoco/org.jacoco.agent-0.8.7-runtime.jar=includes=*,output=tcpserver,port=12345,address=* \
        -Dfile.encoding=UTF-8 \
        -Dserver.port=8080 \
        "-Dspring.datasource.url=jdbc:mysql://localhost:3306/notebook_manager?createDatabaseIfNotExist=true&useSSL=false&allowPublicKeyRetrieval=true" \
        -Dspring.datasource.username=root \
        -Dspring.datasource.password=root123 \
        -Dspring.jpa.hibernate.ddl-auto=none \
        -jar /api/notebookmanager.jar
