FROM hairyhenderson/gomplate:v5.3.1-alpine@sha256:d2403a37221f2b784cafc8a1daf7ad2633fa696012ed58649a917fe91c108939

COPY pdns.conf.tpl /pdns.conf.tpl

# Create user with same UID/GID as pdns user in pdns-auth image
RUN addgroup -g 1000 pdns \
    && adduser -D -u 1000 -G pdns pdns

RUN mkdir -p /etc/pdns \
    && chown -R pdns:pdns /etc/pdns

USER pdns

ENTRYPOINT ["sh", "-c", "gomplate -f /pdns.conf.tpl -o /etc/pdns/pdns.conf && chown pdns:pdns /etc/pdns/pdns.conf"]
