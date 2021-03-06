FROM openjdk:8-jdk-alpine

VOLUME /tmp
WORKDIR /opt/mylist

ENV TIMEZONE Asia/Shanghai
ENV TZ=Asia/Shanghai
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Asia/Shanghai" > /etc/timezone

ADD config/application.yml config/application.yml
ADD jar/MyList-0.0.1-SNAPSHOT.jar jar/app.jar
ADD static/MyList static/MyList
ADD sql sql

ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/opt/mylist/jar/app.jar"]
