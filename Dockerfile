FROM ubuntu:22.04

ENV API=notebook-manager
ENV DEBIAN_FRONTEND=noninteractive

RUN mkdir /api && \
    mkdir /infrastructure && \
    mkdir /results

RUN apt update && \
    apt -y upgrade && \
    apt -y install openjdk-11-jdk python3 python3-pip mysql-server && \
    pip3 install mitmproxy && \
    apt -y autoremove && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./apis/notebook-manager/notebookmanager.jar /api/notebookmanager.jar
COPY ./apis/notebook-manager/classes/ /api/classes/
COPY ./apis/notebook-manager/database/ /api/database/
COPY ./apis/notebook-manager/entrypoint.sh /entrypoint.sh
COPY ./infrastructure/ /infrastructure/

RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
