Verwendung von sshd
===================

Dieser SSH-Daemon dient als Zugangs-Server für in internen Netzen befindliche Services wie Z.B Datenbanken.

Einen sshd manuell starten
--------------------------

Ein simpler Aufruf auf einem solchen Docker-Host sieht wie folgt aus:

```sh
docker run \
    -e USER_KEYS_SYSOP="..." \
    -d \
    -p 55022:22 \
    n4de/sshd
```

Beachtet werden muss zusätzlich, dass ggf. noch ein Netz mit `--network NAME` angegeben werden muss, damit der gestartete _sshd_ Zugriff auf die im Netz befindlichen Ressourcen erhält.

Einen sshd in in einer Stack-Konfiguration starten
--------------------------------------------------

Üblicherweise wird man _sshd_ über eine Stack-Deploy-Datei (z.B. `docker-compose.yml`) starten und verwalten wollen.

Eine Beispiel-Konfiguration könnte wie folgt aussehen:

```yaml
version: "3.4"

services:
  sshd:
    image: n4de/sshd
    environment:
      USER_KEYS_SYSOP: |-
        Key 1
        Key 2
        Key 3
    ports:
      - "55022:22"
    networks:
      - backend

networks:
  backend:
    driver: overlay
    internal: true  # Instanzen dieses Netzes erhalten keinen Zugang zum öffentlichen Netz
```