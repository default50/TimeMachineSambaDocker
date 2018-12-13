FROM alpine:latest
MAINTAINER Sebastian Cruz <default50@gmail.com>


RUN apk add --update \
    avahi \
    samba-common-tools \
    samba-client \
    samba-server \
    shadow \
    supervisor \
    && sed -i 's/#enable-dbus=yes/enable-dbus=no/g' /etc/avahi/avahi-daemon.conf \
    && sed -i 's/CREATE_MAIL_SPOOL=yes/CREATE_MAIL_SPOOL=no/g' /etc/default/useradd \
    && rm -rf /var/cache/apk/*


COPY setup.sh template_quota /tmp/
COPY smb.conf /etc/samba/smb.conf
COPY timemachine_avahi.service /etc/avahi/services/timemachine_avahi.service
COPY supervisord.conf /etc/supervisord.conf


VOLUME ["/timemachine"]
ENTRYPOINT ["/tmp/setup.sh"]
HEALTHCHECK --interval=5m --timeout=3s \
  CMD (avahi-daemon -c && \
        smbclient -L '\\localhost' -U '%' -m SMB3 &>/dev/null) || exit 1
CMD ["supervisord", "--nodaemon", "--configuration", "/etc/supervisord.conf"]
