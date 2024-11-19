### Building
```console
docker pull mariadb:lts
docker build -t northn/mariadb_backupper .
```

### Docker Compose
```yaml
services:
  backupper:
    image: northn/mariadb_backupper
    volumes:
      - ./data/backups:/backups
    environment:
      - DB_HOST=${DB_HOST}
      - DB_PORT=${DB_PORT} # 3306 by default
      - DB_USER=${DB_USER}
      - DB_PASSWORD_FILE=/run/secrets/db_password # both _FILE and simple envvars are supported
      - DB_NAME=${DB_NAME}
      - CRON_INTERVAL="0 */12 * * *" # every 12 hours
    secrets:
      - db_password

secrets:
  db_password:
    file: db_password.txt
```
