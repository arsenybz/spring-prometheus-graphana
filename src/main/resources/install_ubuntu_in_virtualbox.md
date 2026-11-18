

Откуда скачать образ Ubuntu
https://drive.google.com/drive/folders/1fsKXe7wOt5Jx25_4WuvU9UKflWtO37nR


Settings ->

Storage - Controller IDE (либо добавить, вторая иконка с крестиком справа внизу)

Справа появится синий диск - загрузить через него iso

Network - NAT
Advenced -> Port forwarding -> | SSH |  TCP |  тут пусто | 2222 | тут пусто | 22

General -> Advanced -> Shared Clipboard и Drag n Drop выставить в Bidirectional - для копирования и вставки в виртуалку

Settings -> System -> Processor -> указать нужное количество ядер


Enable IO Apic ??? вроде не надо...





Дальше, нажать start. Установить Ubuntu. Язык выбрать русский, установить ssh, не пропускать ввод логина и пароля

Когда появится сообщение Instalation completed, можно заходить в терминал (вроде F7)

Установить ssh, если не устанавливал

sudo apt update && sudo apt install openssh-server
****
****Включить его

sudo systemctl enable ssh --now

Проверить что разрешен пароль по вводу
sudo nano /etc/ssh/sshd_config

Должно быть PasswordAuthentication yes

Найти внутренний ip машины

ip a
(должно быть что-то вроде 10.0.2.15)


Настроить, чтобы было копирование из буфера обмена

sudo apt update && sudo apt install virtualbox-guest-additions-iso


Подключиться по ssh из хоста к виртуалке

ssh имя_пользователя@127.0.0.1 -p 2222





--------------------------------------


Установить прометеус

wget https://github.com/prometheus/prometheus/releases/download/v3.15.1/prometheus-3.15.1.linux-amd64.tar.gz

tar -xvf prometheus-3.15.1.linux-amd64.tar.gz

cd prometheus-3.15.1.linux-amd64/


vim /etc/prometheus/prometheus.yml


Добавить конфиг

sudo systemctl edit --full --force prometheus.service




[Unit]
Description=Prometheus
Wants=network-online.target
After=network-online.target

[Service]
User=prometheus
Group=prometheus
Type=simple
ExecStart=/usr/local/bin/prometheus \
--config.file=/etc/prometheus/prometheus.yml \
--storage.tsdb.path=/var/lib/prometheus/

[Install]
WantedBy=multi-user.target




sudo systemctl daemon-reload

sudo systemctl start prometheus.service

sudo systemctl status  prometheus.service





wget https://github.com/grafana/grafana/releases/download/v13.2.5/grafana_13.2.5_40359240686_linux_amd64.deb

sudo dpkg -i grafana_13.2.5_40359240686_linux_amd64.deb

sudo /bin/systemctl daemon-reload
sudo /bin/systemctl enable grafana-server
sudo systemctl status grafana-server
sudo systemctl status grafana-server

перезапустить виртуалку

sudo chown -R grafana:grafana /usr/share/grafana/
sudo chown -R grafana:grafana /var/log/grafana/
sudo chown -R grafana:grafana /var/lib/grafana/
sudo chown -R grafana:grafana /etc/grafana/
sudo systemctl daemon-reload
sudo systemctl start grafana-server
sudo systemctl status grafana-server



При запуске виртуалки не забыть выполнить
sudo systemctl start prometheus.service




Установить node_exporter

sudo useradd --no-create-home --shell /bin/false node_exporter

wget https://github.com/prometheus/node_exporter/releases/download/v1.12.1/node_exporter-1.12.1.linux-amd64.tar.gz

tar xvf node_exporter-1.12.1.linux-amd64.tar.gz

sudo cp node_exporter-1.12.1.linux-amd64/node_exporter /usr/local/bin/

sudo cp node_exporter-1.12.1.linux-amd64/node_exporter /usr/local/bin/

rm -rf node_exporter-1.12.1.linux-amd64


sudo nano /etc/systemd/system/node_exporter.service


```
[Unit]
Description=Node Exporter
Wants=network.target
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter
Restart=always
RestartSec=10s

[Install]
WantedBy=multi-user.target
```


sudo systemctl daemon-reload

sudo systemctl start node_exporter.service
sudo systemctl status node_exporter.service



Прописать порт в prometheus

```yaml
global:
  scrape_interval: 5s 
  evaluation_interval: 5s

scrape_configs:
  - job_name: "prometheus"
    scrape_interval: 5s
    static_configs:
      - targets: ["localhost:9090", "localhost:9100"]
 # - job_name: "postgresql"
  #  scrape_interval: 5s
 #   static_configs:
  #    - targets: ["localhost:9187"]

```


sudo systemctl restart prometheus.service
sudo systemctl status prometheus.service

Добавить дашборд 14513

http://127.0.0.1:3000/dashboard/import




chown -R grafana:grafana /var/lib/grafana/plugins/

sudo chmod -R 0700 /var/lib/grafana/plugins/


sudo chmod -R 0700 /usr/share/grafana/
sudo chmod -R 0700 /var/log/grafana/
sudo chmod -R 0700 /var/lib/grafana/
sudo chmod -R 0700 /etc/grafana/




Установить postgres

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget -qO- https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo tee /etc/apt/trusted.gpg.d/pgdg.asc &>/dev/null



sudo apt install postgresql postgresql-client -y

???не надо скорее всего
sudo apt install postgresql postgresql-contrib -y

sudo su postgres

psql

select version();

\q

exit

sudo sh -c 'echo "listen_addresses = '"'*'"'" >> /etc/postgresql/14/main/postgresql.conf'

чтобы скопировать команду в файл
sudo scp -P 2222 ~/ubuntu22server.sh ars@127.0.0.1:/home/ars
echo "" > ubuntu22server.sh

ssh ars@127.0.0.1 -p 2222


Перед копированием выполнить File -> Settings -> Editor -> Code Style -> Markdown -> Use tab characer = true, Smart = false
а также перед печатанием указать в файле Tab снизу справа
	
sudo sh -c 'echo "host	all	all	0.0.0.0/0	scram-sha-256" >> /etc/postgresql/14/main/pg_hba.conf'

sudo sed -i 's|host	all	all	127.0.0.1/32	scram-sha-256|host	all	all	127.0.0.1/32	trust|g' /etc/postgresql/14/main/pg_hba.conf
(НЕ РАБОТАЕТ КОМАНДА! ИСКАТЬ ВРУЧНУЮ И МЕНЯТЬ trust)

sudo systemctl restart postgresql.service

sudo psql -U postgres -h 127.0.0.1 -c "alter user postgres with password 'postgres';"


wget https://github.com/prometheus-community/postgres_exporter/releases/download/v0.14.0/postgres_exporter-0.14.0.linux-amd64.tar.gz


tar -xzvf postgres_exporter-0.14.0.linux-amd64.tar.gz




sudo mv postgres_exporter-0.14.0.linux-amd64/postgres_exporter  /usr/bin/



sudo vim /etc/systemd/system/postgres_exporter.service


```
[Unit]
Description=Prometheus PostgreSQL Exporter
After=network.target

[Service]
Type=simple
Restart=always
User=postgres
Group=postgres
Environment=DATA_SOURCE_NAME=postgresql://postgres:postgres@127.0.0.1:5432/postgres?sslmode=disable
ExecStart=/usr/bin/postgres_exporter

[Install]
WantedBy=multi-user.target
```

sudo systemctl daemon-reload

sudo systemctl start postgres_exporter

sudo systemctl status postgres_exporter

sudo vim /etc/prometheus/prometheus.yml

```yaml
global:
  scrape_interval: 5s 
  evaluation_interval: 5s

scrape_configs:
  - job_name: "prometheus"
    scrape_interval: 5s
    static_configs:
      - targets: ["localhost:9090", "localhost:9100"]
  - job_name: "postgresql"
    scrape_interval: 5s
    static_configs:
      - targets: ["localhost:9187"]

```

sudo systemctl restart prometheus

sudo systemctl status prometheus


Выполнить импорт дашборда 9628 в графана
и 12273

В 12273 - выбрать порт 9187

Увидишь, что во вкладке Overview не видны Uptime postgres

Как это исправить:



sudo vim /etc/systemd/system/postgres_exporter.service

```
[Unit]
Description=Prometheus PostgreSQL Exporter
After=network.target

[Service]
Type=simple
Restart=always
User=postgres
Group=postgres
Environment=DATA_SOURCE_NAME=postgresql://postgres:postgres@127.0.0.1:5432/postgres?sslmode=disable
Environment=PG_EXPORTER_EXTEND_QUERY_PATH=/var/lib/postgresql/queries.yaml
ExecStart=/usr/bin/postgres_exporter

[Install]
WantedBy=multi-user.target
```

sudo touch /var/lib/postgresql/queries.yaml


взято отсюда https://github.com/prometheus-community/postgres_exporter/commit/fe960c6b54d8b308d0c0af5a85dfb925cb65e1ed#diff-996ccb161dc17b823796091b615a7a170f52ec79eaa4f69093a519498d1356f6




```declarative
pg_replication:
  query: "SELECT CASE WHEN NOT pg_is_in_recovery() THEN 0 ELSE GREATEST (0, EXTRACT(EPOCH FROM (now() - pg_last_xact_replay_timestamp()))) END AS lag"
  master: true
  metrics:
    - lag:
        usage: "GAUGE"
        description: "Replication lag behind master in seconds"

pg_postmaster:
  query: "SELECT pg_postmaster_start_time as start_time_seconds from pg_postmaster_start_time()"
  master: true
  metrics:
    - start_time_seconds:
        usage: "GAUGE"
        description: "Time at which postmaster started"

pg_stat_user_tables:
  query: |
   SELECT
     current_database() datname,
     schemaname,
     relname,
     seq_scan,
     seq_tup_read,
     idx_scan,
     idx_tup_fetch,
     n_tup_ins,
     n_tup_upd,
     n_tup_del,
     n_tup_hot_upd,
     n_live_tup,
     n_dead_tup,
     n_mod_since_analyze,
     COALESCE(last_vacuum, '1970-01-01Z') as last_vacuum,
     COALESCE(last_autovacuum, '1970-01-01Z') as last_autovacuum,
     COALESCE(last_analyze, '1970-01-01Z') as last_analyze,
     COALESCE(last_autoanalyze, '1970-01-01Z') as last_autoanalyze,
     vacuum_count,
     autovacuum_count,
     analyze_count,
     autoanalyze_count
   FROM
     pg_stat_user_tables
  metrics:
    - datname:
        usage: "LABEL"
        description: "Name of current database"
    - schemaname:
        usage: "LABEL"
        description: "Name of the schema that this table is in"
    - relname:
        usage: "LABEL"
        description: "Name of this table"
    - seq_scan:
        usage: "COUNTER"
        description: "Number of sequential scans initiated on this table"
    - seq_tup_read:
        usage: "COUNTER"
        description: "Number of live rows fetched by sequential scans"
    - idx_scan:
        usage: "COUNTER"
        description: "Number of index scans initiated on this table"
    - idx_tup_fetch:
        usage: "COUNTER"
        description: "Number of live rows fetched by index scans"
    - n_tup_ins:
        usage: "COUNTER"
        description: "Number of rows inserted"
    - n_tup_upd:
        usage: "COUNTER"
        description: "Number of rows updated"
    - n_tup_del:
        usage: "COUNTER"
        description: "Number of rows deleted"
    - n_tup_hot_upd:
        usage: "COUNTER"
        description: "Number of rows HOT updated (i.e., with no separate index update required)"
    - n_live_tup:
        usage: "GAUGE"
        description: "Estimated number of live rows"
    - n_dead_tup:
        usage: "GAUGE"
        description: "Estimated number of dead rows"
    - n_mod_since_analyze:
        usage: "GAUGE"
        description: "Estimated number of rows changed since last analyze"
    - last_vacuum:
        usage: "GAUGE"
        description: "Last time at which this table was manually vacuumed (not counting VACUUM FULL)"
    - last_autovacuum:
        usage: "GAUGE"
        description: "Last time at which this table was vacuumed by the autovacuum daemon"
    - last_analyze:
        usage: "GAUGE"
        description: "Last time at which this table was manually analyzed"
    - last_autoanalyze:
        usage: "GAUGE"
        description: "Last time at which this table was analyzed by the autovacuum daemon"
    - vacuum_count:
        usage: "COUNTER"
        description: "Number of times this table has been manually vacuumed (not counting VACUUM FULL)"
    - autovacuum_count:
        usage: "COUNTER"
        description: "Number of times this table has been vacuumed by the autovacuum daemon"
    - analyze_count:
        usage: "COUNTER"
        description: "Number of times this table has been manually analyzed"
    - autoanalyze_count:
        usage: "COUNTER"
        description: "Number of times this table has been analyzed by the autovacuum daemon"

pg_statio_user_tables:
  query: "SELECT current_database() datname, schemaname, relname, heap_blks_read, heap_blks_hit, idx_blks_read, idx_blks_hit, toast_blks_read, toast_blks_hit, tidx_blks_read, tidx_blks_hit FROM pg_statio_user_tables"
  metrics:
    - datname:
        usage: "LABEL"
        description: "Name of current database"
    - schemaname:
        usage: "LABEL"
        description: "Name of the schema that this table is in"
    - relname:
        usage: "LABEL"
        description: "Name of this table"
    - heap_blks_read:
        usage: "COUNTER"
        description: "Number of disk blocks read from this table"
    - heap_blks_hit:
        usage: "COUNTER"
        description: "Number of buffer hits in this table"
    - idx_blks_read:
        usage: "COUNTER"
        description: "Number of disk blocks read from all indexes on this table"
    - idx_blks_hit:
        usage: "COUNTER"
        description: "Number of buffer hits in all indexes on this table"
    - toast_blks_read:
        usage: "COUNTER"
        description: "Number of disk blocks read from this table's TOAST table (if any)"
    - toast_blks_hit:
        usage: "COUNTER"
        description: "Number of buffer hits in this table's TOAST table (if any)"
    - tidx_blks_read:
        usage: "COUNTER"
        description: "Number of disk blocks read from this table's TOAST table indexes (if any)"
    - tidx_blks_hit:
        usage: "COUNTER"
        description: "Number of buffer hits in this table's TOAST table indexes (if any)"

#
# WARNING: 
#   This set of metrics can be very expensive on a busy server as every
#   unique query executed will create an additional time series
#
# pg_stat_statements:
#   query: |
#     SELECT
#       pg_get_userbyid(userid) as user,
#       pg_database.datname,
#       pg_stat_statements.queryid,
#       pg_stat_statements.calls as calls_total,
#       pg_stat_statements.total_time / 1000.0 as seconds_total,
#       pg_stat_statements.rows as rows_total,
#       pg_stat_statements.blk_read_time / 1000.0 as block_read_seconds_total,
#       pg_stat_statements.blk_write_time / 1000.0 as block_write_seconds_total
#       FROM pg_stat_statements
#       JOIN pg_database
#         ON pg_database.oid = pg_stat_statements.dbid
#       WHERE
#         total_time > (
#           SELECT percentile_cont(0.1)
#             WITHIN GROUP (ORDER BY total_time)
#             FROM pg_stat_statements
#         )
#       ORDER BY seconds_total DESC
#       LIMIT 100
#   metrics:
#     - user:
#         usage: "LABEL"
#         description: "The user who executed the statement"
#     - datname:
#         usage: "LABEL"
#         description: "The database in which the statement was executed"
#     - queryid:
#         usage: "LABEL"
#         description: "Internal hash code, computed from the statement's parse tree"
#     - calls_total:
#         usage: "COUNTER"
#         description: "Number of times executed"
#     - seconds_total:
#         usage: "COUNTER"
#         description: "Total time spent in the statement, in seconds"
#     - rows_total:
#         usage: "COUNTER"
#         description: "Total number of rows retrieved or affected by the statement"
#     - block_read_seconds_total:
#         usage: "COUNTER"
#         description: "Total time the statement spent reading blocks, in seconds"
#     - block_write_seconds_total:
#         usage: "COUNTER"
#         description: "Total time the statement spent writing blocks, in seconds"

pg_process_idle:
  query: |
    WITH
      metrics AS (
        SELECT
          application_name,
          SUM(EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - state_change))::bigint)::float AS process_idle_seconds_sum,
          COUNT(*) AS process_idle_seconds_count
        FROM pg_stat_activity
        WHERE state = 'idle'
        GROUP BY application_name
      ),
      buckets AS (
        SELECT
          application_name,
          le,
          SUM(
            CASE WHEN EXTRACT(EPOCH FROM (CURRENT_TIMESTAMP - state_change)) <= le
              THEN 1
              ELSE 0
            END
          )::bigint AS bucket
        FROM
          pg_stat_activity,
          UNNEST(ARRAY[1, 2, 5, 15, 30, 60, 90, 120, 300]) AS le
        GROUP BY application_name, le
        ORDER BY application_name, le
      )
    SELECT
      application_name,
      process_idle_seconds_sum as seconds_sum,
      process_idle_seconds_count as seconds_count,
      ARRAY_AGG(le) AS seconds,
      ARRAY_AGG(bucket) AS seconds_bucket
    FROM metrics JOIN buckets USING (application_name)
    GROUP BY 1, 2, 3
  metrics:
    - application_name:
        usage: "LABEL"
        description: "Application Name"
    - seconds:
        usage: "HISTOGRAM"
        description: "Idle time of server processes"
```


sudo  vim /var/lib/postgresql/queries.yaml

sudo systemctl daemon-reload

sudo systemctl restart node_exporter


зайти в редактирование метрики для Uptime 

http://127.0.0.1:3000/d/5474745/postgresql-overview-postgres-exporter?var-interval=$__auto&from=now-1h&to=now&timezone=browser&var-namespace=&var-release=&var-instance=localhost:9187&var-datname=$__all&var-mode=$__all&refresh=5m&editPanel=164

поменять
pg_postmaster_start_time_seconds{release="$release", instance="$instance"} * 1000

на 

pg_postmaster{release="$release", instance="$instance"} * 1000

сохранить

Пробросить в virtualbox порт 9187

Зайти на сайт http://127.0.0.1:9187/ проверить что экспортер виден извне


Заходим в http://127.0.0.1:9187/metrics

и ищем что-то по словам start time 

и оказывается нужна метрика process_start_time_seconds

Заменяем 

pg_postmaster{release="$release", instance="$instance"} * 1000

на 

process_start_time_seconds{release="$release", instance="$instance"} * 1000

Сохраняем, и видим что метрика в grafana теперь работает


Также и с размером базы данных - заходим в метрику Database size, проверяем что метрика теперь
называется pg_database_size_bytes, меняем и получаем рабочий график


Теперь, можно делать тестовую нагрузку на базу данных


psql

create database test;

\q

pgbench -i test


pgbench -c 50 -C -j  2 -P 10  -T  30 -M extended test



