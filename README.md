Verwendung von sshd
===================

Dieser SSH-Daemon dient als Zugangs-Server für in internen Netzen befindliche Services wie Z.B Datenbanken.

Dabei wird davon ausgegangen, dass eine auf dem Docker-Host befindliche `authorized_keys` Datei als read-only-Volume in den zu startenden Container eingebunden wird. Nur so ist auch später ein Login per SSH mit dem Benutzernamen _sysop_ möglich.

Einen sshd manuell starten
--------------------------

Vor dem Start eines _sshd_ wird eine `authorized_keys` Datei benötigt, die die zugelassenen SSH-Keys enthält. Diese Datei muss zudem dem Benutzer mit der _ID 1000_ gehören. Dies entspricht bei modernen Linux-Systemen dem Standardbenutzer. Auf unseren AlpineLinux Docker-Hosts hat der Benutzer _docker_ diese ID.

Ein simpler Aufruf auf einem solchen Docker-Host sieht daher wie folgt aus:

```sh
docker run \
    -d \
    -p 55022:22 \
    -v "/home/docker/.ssh/authorized_keys:/home/sysop/.ssh/authorized_keys:ro" \
    registry.n4group.eu/n4de/sshd
```

Beachtet werden muss zusätzlich, dass ggf. noch ein Netz mit `--network NAME` angegeben werden muss, damit der gestartete _sshd_ Zugriff auf die im Netz befindlichen Ressourcen erhält.

Einen sshd in in einer Stack-Konfiguration starten
--------------------------------------------------

Üblicherweise wird man _sshd_ über eine Stack-Deploy-Datei (z.B. `docker-compose.yml`) starten und verwalten wollen.

Eine Beispiel-Konfiguration könnte wie folgt aussehen:

```yaml
version: "3"

services:
  sshd:
    image: registry.n4group.eu/n4de/sshd
    deploy:
      mode: global
    ports:
      - "55022:22"
    volumes:
      - "/home/docker/.ssh/authorized_keys:/home/sysop/.ssh/authorized_keys:ro"
    networks:
      - backend

networks:
  backend:
    driver: overlay
    internal: true  # Services haben keinen Zugang zum öffentlichen Netz
```