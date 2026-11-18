psql -U postgres_user -d postgres_db


docker run -d \
   --name postgres-exporter \
   -p 9187:9187 \
   -e DATA_SOURCE_NAME="postgresql://postgres_user:demo@localhost:5432/postgres?sslmode=disable" \
   quay.io/prometheuscommunity/postgres-exporter

Открыть prafana
Укзаать: Data Sources -> Prometheus -> http://prometheus_pg:9187

Скачать дашборды для postgres
https://grafana.com/grafana/dashboards/9628-postgresql-database/

https://grafana.com/grafana/dashboards/14513-linux-exporter-node/

Очистка всего
docker stop $(docker ps -q)
docker rm $(docker ps -a -q)
docker rmi -f $(docker images -qa)
docker volume rm $(docker volume ls -q)
docker network rm $(docker network ls -q)
docker system prune -a --volumes

!!! не забыть удалить все директории volumes с локального компьютера, например 
sudo rm -rf ~/projects/spring-prometheus-graphana/src/main/resources/pgdata/
!!! 



Чтобы проверить что postgres_exporter работает
http://localhost:9187/metrics




time=2026-10-25T12:32:53.643Z level=ERROR source=postgres_exporter.go:606 msg="error scraping dsn" err="Error opening connection to database (postgresql://:PASSWORD_REMOVED@postgresql://postgres:postgres@host.docker.internal.test123:5432/demo?sslmode=disable): dial tcp: lookup postgresql on 127.0.0.11:53: server misbehaving" dsn="postgresql://:PASSWORD_REMOVED@postgresql://postgres:postgres@host.docker.internal.test123:5432/demo?sslmode=disable"
time=2026-10-25T12:32:57.640Z level=INFO source=server.go:96 msg="Established new database connection" fingerprint=postgresql:5432
time=2026-10-25T12:32:57.642Z level=ERROR source=collector.go:191 msg="Error opening connection to database" err="error querying postgresql version: dial tcp: lookup postgresql on 127.0.0.11:53: server misbehaving"
time=2026-10-25T12:32:58.642Z level=ERROR source=postgres_exporter.go:606 msg="error scraping dsn" err="Error opening connection to database (postgresql://:PASSWORD_REMOVED@postgresql://postgres:postgres@host.docker.internal.test123:5432/demo?sslmode=disable): dial tcp: lookup postgresql on 127.0.0.11:53: server misbehaving" dsn="postgresql://:PASSWORD_REMOVED@postgresql://postgres:postgres@host.docker.internal.test123:5432/demo?sslmode=disable"


time=2026-10-25T12:41:58.512Z level=ERROR source=postgres_exporter.go:606 msg="error scraping dsn" err="Error opening connection to database (postgresql://:PASSWORD_REMOVED@postgresql://postgres:postgres@host.docker.internal:5432/demo?sslmode=disable): dial tcp: lookup postgresql on 127.0.0.11:53: server misbehaving" dsn="postgresql://:PASSWORD_REMOVED@postgresql://postgres:postgres@host.docker.internal:5432/demo?sslmode=disable"
time=2026-10-25T12:42:02.510Z level=INFO source=server.go:96 msg="Established new database connection" fingerprint=postgresql:5432
time=2026-10-25T12:42:07.510Z level=INFO source=server.go:96 msg="Established new database connection" fingerprint=postgresql:5432
time=2026-10-25T12:42:07.512Z level=ERROR source=collector.go:191 msg="Error opening connection to database" err="error querying postgresql version: dial tcp: lookup postgresql on 127.0.0.11:53: server misbehaving"


time=2026-10-25T12:55:23.348Z level=ERROR source=collector.go:191 msg="Error opening connection to database" err="error querying postgresql version: dial tcp: lookup postgresql on 127.0.0.11:53: server misbehaving"
time=2026-10-25T12:55:24.348Z level=ERROR source=postgres_exporter.go:606 msg="error scraping dsn" err="Error opening connection to database (postgresql://:PASSWORD_REMOVED@postgresql://postgres@host.docker.internal:5432/postgres?sslmode=disable): dial tcp: lookup postgresql on 127.0.0.11:53: server misbehaving" dsn="postgresql://:PASSWORD_REMOVED@postgresql://postgres@host.docker.internal:5432/postgres?sslmode=disable"
time=2026-10-25T12:55:28.344Z level=INFO source=server.go:96 msg="Established new database connection" fingerprint=postgresql:5432
time=2026-10-25T12:55:28.346Z level=ERROR source=collector.go:191 msg="Error opening connection to database" err="error querying postgresql version: dial tcp: lookup postgresql on 127.0.0.11:53: server misbehaving"
time=2026-10-25T12:55:29.346Z level=ERROR source=postgres_exporter.go:606 msg="error scraping dsn" err="Error opening connection to database (postgresql://:PASSWORD_REMOVED@postgresql://postgres@host.docker.internal:5432/postgres?sslmode=disable): dial tcp: lookup postgresql on 127.0.0.11:53: server misbehaving" dsn="postgresql://:PASSWORD_REMOVED@postgresql://postgres@host.docker.internal:5432/postgres?sslmode=disable"


time=2026-10-25T13:03:22.205Z level=INFO source=server.go:96 msg="Established new database connection" fingerprint=postgresql:5432
time=2026-10-25T13:03:22.207Z level=ERROR source=collector.go:191 msg="Error opening connection to database" err="error querying postgresql version: dial tcp: lookup postgresql on 127.0.0.11:53: server misbehaving"
time=2026-10-25T13:03:23.208Z level=ERROR source=postgres_exporter.go:606 msg="error scraping dsn" err="Error opening connection to database (postgresql://:PASSWORD_REMOVED@postgresql://postgres:postgres@host.docker.internal:5432/?sslmode=disable): dial tcp: lookup postgresql on 127.0.0.11:53: server misbehaving" dsn="postgresql://:PASSWORD_REMOVED@postgresql://postgres:postgres@host.docker.internal:5432/?sslmode=disable"




psql --username=postgres_user postgres < /tmp/demo-20250901-6m.sql.gz

Зайти в образ
docker exec -it postgres_container bash
apt update
apt install vim
apt install sudo

vim /var/lib/postgresql/data/pgdata/postgresql.conf

указать
shared_preload_libraries = 'pg_stat_statements'


Для перезапуска postgres
sudo /etc/init.d/postgresql stop

И получаю ошибку:
Postgresql - No PostgreSQL clusters exist; see "man pg_createcluster" during service restart

Она означает что остановить удалось, но не удалось запустить потому что нет ни одного кластера. Надо добавить

Проверяем
sudo /etc/init.d/postgresql start
- то же самое...

Как исправить

sudo pg_createcluster 18 main

pg_ctlcluster <pg version> <cluster name> <start|stop>
pg_ctlcluster 18 main start

pg_ctlcluster -m fast 18 main stop

Теперь если выполним остановку и запуск - /ect/init.d/postgres stop или start работает

root@639cdc09f37e:/# sudo /etc/init.d/postgresql stop
Stopping PostgreSQL 18 database server: main.
root@639cdc09f37e:/# sudo /etc/init.d/postgresql start
Starting PostgreSQL 18 database server: main.

После перезапуска зайти в постгрес просто так не удастся
Надо заходить под postgres

sudo -u postgres psql -p 5433

Выполнить команду
CREATE EXTENSION pg_stat_statements;


После перезапуска опять удаляются роли
запустить
psql -U postgres_user -d postgres -p 5432


Для выхода из режима чтения запросы нажать - q



..... в итоге не получилось, остановился на том что ошибка в quay.io/prometheuscommunity/postgres-exporter

time=2026-10-25T12:42:02.511Z level=ERROR source=collector.go:191 msg="Error opening connection to database" err="error querying postgresql version: dial tcp: lookup postgresql on 127.0.0.11:53: server misbehaving"
time=2026-10-25T12:42:03.511Z level=ERROR source=postgres_exporter.go:606 msg="error scraping dsn" err="Error opening connection to database (postgresql://:PASSWORD_REMOVED@postgresql://postgres:postgres@host.docker.internal:5432/demo?sslmode=disable): dial tcp: lookup postgresql on 127.0.0.11:53: server misbehaving" dsn="postgresql://:PASSWORD_REMOVED@postgresql://postgres:postgres@host.docker.internal:5432/demo?sslmode=disable"

перешел на VirtualBox


