# pdns-auth-init-conf

Small init-container image based on [gomplate](https://github.com/hairyhenderson/gomplate) to create basic configuration for a PowerDNS authoritative instance (pdns-auth). Intended to use in docker-compose or kubernetes as `initContainer` that writes initial config files into a shared volume before the main pdns container starts.


## Features
- Minimal purpose-built image
- Writes configuration files to /etc/pdns/pdns.conf
- Keeps runtime image simple and reproducible
- All environment variables are translated into corresponding pdns.conf settings, so you can use any option from the [official PowerDNS documentation](https://doc.powerdns.com/authoritative/settings.html). `PDNS_` will be stripped, `_` will be replaced with `-` and the key will be converted to lower case.
    - Example: `PDNS_GPGSQL_DBNAME=pdns` translates to `gpgsql-dbname=pdns`
 
## Quick usage
### Docker compose
Mount a shared volume and first run the `pdns-auth-init-conf` container and a `pdns-auth` container afterwards.
```yaml
service:
  pdns-auth-init-conf:
    image: registry.gitlab.com/joern_schonhoff/pdns-auth-init-conf:latest
    volumes:
      - pdns-auth-config:/etc/pdns
    environment:
      - 'PNDNS_LAUNCH=bind'
      # More PowerDNS configuration variables
  pdns-auth:
    image: registry.gitlab.com/joern_schonhoff/pdns-auth-distroless:latest
    volumes:
      - pdns-auth-config:/etc/pdns
    depends_on:
      pdns-auth-init-conf:
        condition: service_completed_successfully

volumes:
  pdns-auth-conf:
``` 
### Kubernetes
Mount a shared volume and run this image as an initContainer so the main pdns pod can consume the generated config:

```yaml
initContainers:
  - name: pdns-auth-init
    image: registry.gitlab.com/joern_schonhoff/pdns-auth-init-conf:latest
    volumeMounts:
      - name: pdns-config
        mountPath: /etc/pdns
```

Replace the image reference and add any environment variables or arguments your deployment needs.

## License
MIT

## Author
Joern Schonhoff
