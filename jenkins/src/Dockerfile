FROM jenkins/jenkins:lts-alpine

USER root

RUN apk add --no-cache \
    docker-cli

COPY plugins.txt \
    /usr/share/jenkins/ref/plugins.txt

RUN jenkins-plugin-cli -f \
    /usr/share/jenkins/ref/plugins.txt

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

