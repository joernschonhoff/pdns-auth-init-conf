FROM hairyhenderson/gomplate:v5.2.0-alpine@sha256:045133ce57ef6242787099a99362c4f5e02b6472f1466ddc84cb244426a87fef

COPY pdns.conf.tpl /pdns.conf.tpl

# Create user with same UID/GID as pdns user in pdns-auth image
RUN addgroup -g 1000 pdns \
    && adduser -D -u 1000 -G pdns pdns

RUN mkdir -p /etc/pdns \
    && chown -R pdns:pdns /etc/pdns

USER pdns

ENTRYPOINT ["sh", "-c", "gomplate -f /pdns.conf.tpl -o /etc/pdns/pdns.conf && chown pdns:pdns /etc/pdns/pdns.conf"]
