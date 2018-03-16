ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION}

# add openssh and clean
RUN apk add --update --no-cache openssh-server
# add entrypoint script
ADD docker-entrypoint.sh /
#make sure we get fresh keys
RUN rm -rf /etc/ssh/ssh_host_*_key
#add sysop user
RUN adduser -D sysop && \
    passwd -u sysop && \
    mkdir -p /home/sysop/.ssh && \
    chown sysop.sysop -R /home/sysop/.ssh && \
    chmod 700 /home/sysop/.ssh

EXPOSE 22
ENTRYPOINT ["/docker-entrypoint.sh"]
VOLUME ["/home/sysop/.ssh/authorized_keys"]
CMD ["/usr/sbin/sshd","-D"]
