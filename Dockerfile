ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION}

# HOST_PRIV_KEY_RSA: RSA Private Key - optional
ENV HOST_PRIV_KEY_RSA ""

# HOST_PRIV_KEY_ED25519: Host ED25519 Private Key - optional
ENV HOST_PRIV_KEY_ED25519 ""

# USER_KEYS_ROOT: Public Keys added to the root account
ENV USER_KEYS_ROOT ""

# USER_KEYS_SYSOP: Public Keys added to the sysop account (account is created if variable is in set)
ENV USER_KEYS_SYSOP ""

# SSH_AUTH_KEYS: Public Keys added to the user account 'sysop' (account automatically created if variable is set)
# *DEPRECATED - PLEASE USE USER_KEYS_SYSOP
ENV SSH_AUTH_KEYS ""

RUN apk add -U openssh

COPY files/ /

EXPOSE 22
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd","-D", "-e"]
