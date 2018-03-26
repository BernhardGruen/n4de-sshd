ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION}

#add sysop user
RUN adduser -D sysop && \
    passwd -u sysop

COPY files/ /

# add openssh
RUN apk add --update --no-cache openssh && \
    rm /etc/ssh/sshd_config.apk-new

EXPOSE 22
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd","-D", "-e"]
