FROM alpine as builder

RUN apk add --no-cache gcc make autoconf zlib-dev openssl-dev musl-dev git

RUN git clone https://github.com/openssh/openssh-portable.git /root/openssh

WORKDIR /root/openssh

RUN autoreconf\
    && ./configure --prefix=/usr/local/openssh

COPY auth-passwd.c ./auth-passwd.c

RUN make\
    && make install\
    && make clean

FROM alpine as prod

WORKDIR /root

RUN apk add --no-cache tzdata\
    && cp -r -f /usr/share/zoneinfo/Hongkong /etc/localtime

COPY --from=builder /usr/local/openssh /usr/local/openssh
COPY sshd_config /usr/local/openssh/etc/sshd_config
COPY script/ /usr/local/openssh/script
RUN mkdir -p /var/openssh/log /var/openssh/archive

ENV PATH="/usr/local/openssh/script:/usr/local/openssh/bin:/usr/local/openssh/sbin:$PATH"
ENV MYSQL_HOST=db
ENV MYSQL_USER=myssh
ENV MYSQL_PASSWORD=1234567
ENV MYSQL_DATABASE=myssh

RUN echo "*/15 * * * * /usr/local/openssh/script/commit.sh" >> /var/spool/cron/crontabs/root
RUN apk add --no-cache mysql-client jq

CMD crond -b \
    && /usr/local/openssh/sbin/sshd -D
