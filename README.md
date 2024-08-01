# munin-arangodb
ArangoDB plugin for Munin

## install
copy `munin_arangodb.sh` to whatever place, for ex. `/usr/local/munin/plugins/`
```sh
mkdir -p /usr/local/munin/plugins/
cp munin_arangodb.sh /usr/local/munin/plugins/
```

make it executable:
```sh
chmod a+x /usr/local/munin/plugins/munin_arangodb.sh
```

create symlinks in `/etc/munin/plugins/` for each metrics you wish to record, for ex.
```sh
ln -s /usr/local/munin/plugins/munin_arangodb.sh /etc/munin/plugins/arangodb_queries
```
(see "available metrics" below)

restart `munin-node`
```sh
systemctl restart munin-node
```

## available metrics
The following names can be used as symlink names to output different metrics
 * arangodb_arangodump
 * arangodb_connections
 * arangodb_files
 * arangodb_memory
 * arangodb_queries
 * arangodb_rocksdb_compaction
 * arangodb_rocksdb_errors
 * arangodb_rocksdb_wal
 * arangodb_rocksdb_wal_size
 * arangodb_threads

## configuration
Reading metrics from ArangoDB server requires root access.

copy `arangodb.conf.example` to `/etc/munin/plugin-conf.d/`
```sh
cp arangodb.conf.example /etc/munin/plugin-conf.d/arangodb
```

edit `/etc/munin/plugin-conf.d/arangodb` and set `env.password` to your actual ArangoDB root password
