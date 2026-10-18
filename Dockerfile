FROM hairyhenderson/gomplate:v5.3.0-alpine@sha256:f592776a7465f3126350fbf78a8147e2b82e636a94698d9adf637e66aba4cb69

COPY pdns.conf.tpl /pdns.conf.tpl

# Create user with same UID/GID as pdns user in pdns-auth image
RUN addgroup -g 1000 pdns \
    && adduser -D -u 1000 -G pdns pdns

RUN mkdir -p /etc/pdns \
    && chown -R pdns:pdns /etc/pdns

USER pdns

ENTRYPOINT ["sh", "-c", "gomplate -f /pdns.conf.tpl -o /etc/pdns/pdns.conf && chown pdns:pdns /etc/pdns/pdns.conf"]
