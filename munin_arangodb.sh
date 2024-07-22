#!/bin/bash

#
# ArangoDB plugin for Munin
# v0.1 2024-07-22
# Mathias Chouet <mathias.chouet@cirad.fr>
#
# Configuration:
# - copy arangodb.conf.example to /etc/munin/plugin-conf.d/arangodb and
#   configure ArangoDB root password
#
# Requires:
# - cURL
# - base64
#

LOGIN="$login"
PASSWORD="$password"
CACHE_FILE="$tempfile"

output_config() {
	echo "graph_category arangodb"

    case $NAME in
        arangodb_threads)
            echo "graph_title Threads"
            echo "threads.label Total threads"
            echo "threads_awake.label Awake threads"
            echo "threads_detached.label Detached threads"
            echo "threads_worker.label Worker threads"
            echo "threads_working.label Working threads"
            ;;
        arangodb_queries)
            echo "graph_title AQL queries"
            echo "current_queries.label Current queries"
            echo "scheduler_queue_length.label Queue length"
            ;;
        arangodb_memory)
            echo "graph_title Memory"
            echo "aql_global_mem_usage.label Global memory usage"
            ;;
        arangodb_connections)
            echo "graph_title Client connections"
            echo "client_connections.label Connections"
            ;;
        arangodb_files)
            echo "graph_title Files"
            echo "file_descriptors.label File descriptors"
            ;;
        arangodb_rocksdb_wal)
            echo "graph_title RocksDB WAL"
            echo "wal_files_prunable.label Prunable files"
            echo "wal_files_live.label Live files"
            echo "wal_files_archived.label Archived files"
            ;;
        arangodb_rocksdb_wal_size)
            echo "graph_title RocksDB WAL size"
            echo "wal_files_size_archived.label Archived files size"
            echo "rocksdb_live_wal_files_size.label Live files size"
            ;;
        arangodb_rocksdb_errors)
            echo "graph_title RocksDB errors"
            echo "rocksdb_background_errors.label Background errors"
            ;;
        arangodb_rocksdb_compaction)
            echo "graph_title RocksDB compaction"
            echo "rocksdb_compaction_pending.label Compactions pending"
            echo "rocksdb_compaction_running.label Compactions running"
            ;;
        *)
            printf >&2 "plugin name not managed: %s\n" $NAME
            exit 2
            ;;

        # TODO :
        # rocksdb_wal_sequence
        # rocksdb_total_sst_files
        # rocksdb_num_running_flushes
        # …
    esac
}

get_metrics_value() {
    echo "$METRICS" | grep -E "^$1[{ ]" | grep -v 'HELP ' | grep -v 'TYPE ' | cut -d' ' -f2
}

# cache metrics in local file during 3mn
read_metrics() {
    if [ ! -f "$CACHE_FILE" ] || [ ! $(find "$CACHE_FILE" -mmin -3 -print) ]; then
        AUTH=$(echo -ne "$LOGIN:$PASSWORD" | base64 --wrap 0)
        curl -s -H "Content-Type: application/json" -H "Authorization: Basic $AUTH" http://localhost:8529/_admin/metrics/v2 > "$CACHE_FILE"
    fi
    METRICS=`cat $CACHE_FILE`
}

output_values() {
    read_metrics

    case $NAME in
        arangodb_threads)
            VALUE=$(get_metrics_value "arangodb_process_statistics_number_of_threads")
            echo "threads.value $VALUE"
            VALUE=$(get_metrics_value "arangodb_scheduler_num_awake_threads")
            echo "threads_awake.value $VALUE"
            VALUE=$(get_metrics_value "arangodb_scheduler_num_detached_threads")
            echo "threads_detached.value $VALUE"
            VALUE=$(get_metrics_value "arangodb_scheduler_num_worker_threads")
            echo "threads_worker.value $VALUE"
            VALUE=$(get_metrics_value "arangodb_scheduler_num_working_threads")
            echo "threads_working.value $VALUE"
            ;;
        arangodb_queries)
            VALUE=$(get_metrics_value "arangodb_aql_current_query")
            echo "current_queries.value $VALUE"
            VALUE=$(get_metrics_value "arangodb_scheduler_queue_length")
            echo "scheduler_queue_length.value $VALUE"
            ;;
        arangodb_memory)
            VALUE=$(get_metrics_value "arangodb_aql_global_memory_usage")
            echo "aql_global_mem_usage.value $VALUE"
            ;;
        arangodb_connections)
            VALUE=$(get_metrics_value "arangodb_client_connection_statistics_client_connections")
            echo "client_connections.value $VALUE"
            ;;
        arangodb_files)
            VALUE=$(get_metrics_value "arangodb_file_descriptors_current")
            echo "file_descriptors.value $VALUE"
            ;;
        arangodb_rocksdb_wal)
            VALUE=$(get_metrics_value "rocksdb_prunable_wal_files")
            echo "wal_files_prunable.value $VALUE"
            VALUE=$(get_metrics_value "rocksdb_live_wal_files")
            echo "wal_files_live.value $VALUE"
            VALUE=$(get_metrics_value "rocksdb_archived_wal_files")
            echo "wal_files_archived.value $VALUE"
            ;;
        arangodb_rocksdb_wal_size)
            VALUE=$(get_metrics_value "rocksdb_archived_wal_files_size")
            echo "wal_files_size_archived.value $VALUE"
            VALUE=$(get_metrics_value "rocksdb_live_wal_files_size")
            echo "wal_files_size_live.value $VALUE"
            ;;
        arangodb_rocksdb_errors)
            VALUE=$(get_metrics_value "rocksdb_background_errors")
            echo "rocksdb_background_errors.value $VALUE"
            ;;
        arangodb_rocksdb_compaction)
            VALUE=$(get_metrics_value "rocksdb_compaction_pending")
            echo "rocksdb_compaction_pending.value $VALUE"
            VALUE=$(get_metrics_value "rocksdb_num_running_compactions")
            echo "rocksdb_compaction_running.value $VALUE"
            ;;
        *)
            printf >&2 "plugin name not managed: %s\n" $NAME
            exit 2
            ;;

        # TODO :
        # rocksdb_wal_sequence
        # rocksdb_total_sst_files
        # rocksdb_num_running_flushes
        # …
    esac
}

output_usage() {
    printf >&2 "%s - ArangoDB plugin for Munin\n" $NAME
    printf >&2 "Usage: %s [config]\n" $NAME
    printf >&2 "Symlink for different outputs:
    arangodb_threads
    arangodb_queries
    arangodb_memory
    arangodb_connections
    arangodb_files
    arangodb_rocksdb_wal
    arangodb_rocksdb_wal_size
    arangodb_rocksdb_errors
    arangodb_rocksdb_compaction
    \n"
}

# plugin name from symlink
NAME="${0##*/}"

# main
case $# in
    0)
        output_values
        ;;
    1)
        case $1 in
            config)
                output_config
                ;;
            *)
                output_usage
                exit 1
                ;;
        esac
        ;;
    *)
        output_usage
        exit 1
        ;;
esac
