FROM alpine

WORKDIR /root

RUN apk add --no-cache tzdata \
    && cp -r -f /usr/share/zoneinfo/Hongkong /etc/localtime

RUN apk add --no-cache mysql-client nmap nmap-scripts

COPY script/ /usr/local/analyse/script

ENV PATH="/usr/local/analyse/script:$PATH"
ENV MYSQL_HOST=db
ENV MYSQL_USER=myssh
ENV MYSQL_PASSWORD=1234567
ENV MYSQL_DATABASE=myssh

CMD run.sh

