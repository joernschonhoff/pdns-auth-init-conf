FROM hairyhenderson/gomplate:v5.1.0-alpine@sha256:b0a9195791abb232d03e7c248b77a56d20e128335b641d8ec157db247d91e58f

COPY pdns.conf.tpl /pdns.conf.tpl

# Create user with same UID/GID as pdns user in pdns-auth image
RUN addgroup -g 1000 pdns \
    && adduser -D -u 1000 -G pdns pdns

RUN mkdir -p /etc/pdns \
    && chown -R pdns:pdns /etc/pdns

USER pdns

ENTRYPOINT ["sh", "-c", "gomplate -f /pdns.conf.tpl -o /etc/pdns/pdns.conf && chown pdns:pdns /etc/pdns/pdns.conf"]
