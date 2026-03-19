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
# CACHE_FILE="/home/chouet/src/munin-arangodb/munin_arangodb_metrics"
CACHE_FILE="$tempfile"

output_config() {
	echo "graph_category arangodb"

    case $NAME in
        arangodb_arangodump)
            echo "graph_title arangodump"
            echo "arangodump_processes.label Running arangodump processes"
            ;;
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
        arangodb_rocksdb_wal_ticks)
            echo "graph_title RocksDB WAL ticks"
            echo "wal_released_tick_flush.label Released tick (flush)"
            echo "wal_released_tick_replication.label Released tick (replication)"
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
        arangodb_rocksdb_engine_throttle)
            echo "graph_title RocksDB engine throttle"
            echo "rocksdb_engine_throttle_bps.label Engine throttle bps"
            ;;
        arangodb_document_read_time)
            echo "graph_title Document read time"
            echo "doc_reads_10µs.label Document read <= 10µs"
            echo "doc_reads_10µs.type DERIVE"
            echo "doc_reads_10µs.draw AREA"
            echo "doc_reads_10µs.min 0"
            echo "doc_reads_1ms.label Document read <= 1ms"
            echo "doc_reads_1ms.type DERIVE"
            echo "doc_reads_1ms.draw STACK"
            echo "doc_reads_1ms.min 0"
            echo "doc_reads_100ms.label Document read <= 100ms"
            echo "doc_reads_100ms.type DERIVE"
            echo "doc_reads_100ms.draw STACK"
            echo "doc_reads_100ms.min 0"
            echo "doc_reads_1s.label Document read <= 1s"
            echo "doc_reads_1s.type DERIVE"
            echo "doc_reads_1s.draw STACK"
            echo "doc_reads_1s.min 0"
            ;;
        arangodb_document_insert_time)
            echo "graph_title Document insert time"
            echo "doc_insert_10µs.label Document insert <= 10µs"
            echo "doc_insert_10µs.type DERIVE"
            echo "doc_insert_10µs.draw AREA"
            echo "doc_insert_10µs.min 0"
            echo "doc_insert_1ms.label Document insert <= 1ms"
            echo "doc_insert_1ms.type DERIVE"
            echo "doc_insert_1ms.draw STACK"
            echo "doc_insert_1ms.min 0"
            echo "doc_insert_100ms.label Document insert <= 100ms"
            echo "doc_insert_100ms.type DERIVE"
            echo "doc_insert_100ms.draw STACK"
            echo "doc_insert_100ms.min 0"
            echo "doc_insert_1s.label Document insert <= 1s"
            echo "doc_insert_1s.type DERIVE"
            echo "doc_insert_1s.draw STACK"
            echo "doc_insert_1s.min 0"
            ;;
        arangodb_document_replace_time)
            echo "graph_title Document replace time"
            echo "doc_replace_10µs.label Document replace <= 10µs"
            echo "doc_replace_10µs.type DERIVE"
            echo "doc_replace_10µs.draw AREA"
            echo "doc_replace_10µs.min 0"
            echo "doc_replace_1ms.label Document replace <= 1ms"
            echo "doc_replace_1ms.type DERIVE"
            echo "doc_replace_1ms.draw STACK"
            echo "doc_replace_1ms.min 0"
            echo "doc_replace_100ms.label Document replace <= 100ms"
            echo "doc_replace_100ms.type DERIVE"
            echo "doc_replace_100ms.draw STACK"
            echo "doc_replace_100ms.min 0"
            echo "doc_replace_1s.label Document replace <= 1s"
            echo "doc_replace_1s.type DERIVE"
            echo "doc_replace_1s.draw STACK"
            echo "doc_replace_1s.min 0"
            ;;
        arangodb_collection_lock_acquisition_time)
            echo "graph_title Collection lock acquisition time"
            echo "lock_acquisition_10µs.label Lock acquisition <= 10µs"
            echo "lock_acquisition_10µs.type DERIVE"
            echo "lock_acquisition_10µs.draw AREA"
            echo "lock_acquisition_10µs.min 0"
            echo "lock_acquisition_1ms.label Lock acquisition <= 1ms"
            echo "lock_acquisition_1ms.type DERIVE"
            echo "lock_acquisition_1ms.draw STACK"
            echo "lock_acquisition_1ms.min 0"
            echo "lock_acquisition_100ms.label Lock acquisition <= 100ms"
            echo "lock_acquisition_100ms.type DERIVE"
            echo "lock_acquisition_100ms.draw STACK"
            echo "lock_acquisition_100ms.min 0"
            echo "lock_acquisition_1s.label Lock acquisition <= 1s"
            echo "lock_acquisition_1s.type DERIVE"
            echo "lock_acquisition_1s.draw STACK"
            echo "lock_acquisition_1s.min 0"
            ;;
        arangodb_scheduler_queue)
            echo "graph_title Scheduler queue"
            echo "scheduler_queue_length.label Queue length"
            echo "scheduler_queue_failures.label Scheduler queue failures"
            ;;
        arangodb_connection_pool)
            echo "graph_title Connections pool"
            echo "pool_connections_current.label Current connections"
            ;;
        arangodb_server_statistics)
            echo "graph_title Server statistics"
            echo "server_statistics_user_percent.label user CPU time %"
            echo "server_statistics_system_percent.label system CPU time %"
            echo "server_statistics_iowait_percent.label iowait CPU time %"
            ;;
        arangodb_process_statistics)
            echo "graph_title Process statistics"
            echo "process_statistics_user_time.label user CPU time"
            echo "process_statistics_system_time.label system CPU time"
            ;;
        arangodb_promises)
            echo "graph_title Async promises"
            echo "existing_promises.label Existing async promises"
            ;;
        arangodb_search_threads)
            echo "graph_title Arangosearch threads"
            echo "search_threads.label Search execution threads demand"
            ;;
        arangodb_collection_lock_time)
            echo "graph_title Collection lock time"
            echo "collection_lock_acquisition_micros_total.label Lock acquisition"
            echo "collection_lock_timeouts_exclusive_total.label Exclusive lock timeouts"
            echo "collection_lock_timeouts_write_total.label Write lock timeouts"
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
    # echo "debug - read cached metrics only, from $CACHE_FILE"
    if [ ! -f "$CACHE_FILE" ] || [ ! $(find "$CACHE_FILE" -mmin -3 -print) ]; then
        AUTH=$(echo -ne "$LOGIN:$PASSWORD" | base64 --wrap 0)
        curl -s -H "Content-Type: application/json" -H "Authorization: Basic $AUTH" http://localhost:8529/_admin/metrics/v2 > "$CACHE_FILE"
    fi
    METRICS=`cat $CACHE_FILE`
}

output_values() {
    if [ $NAME != "arangodb_arangodump" ]; then
        read_metrics
    fi

    case $NAME in
        arangodb_arangodump)
            VALUE=$(ps aux | grep arangodump | grep -v grep | grep -v arangodb_arangodump | wc -l)
            echo "arangodump_processes.value $VALUE"
            ;;
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
            # protection against uint64 overflow bug < 3.12.6 @see https://github.com/arangodb/arangodb/issues/21777
            # if number has more than 10 digits → error
            if [ "${#VALUE}" -gt 10 ]; then
                VALUE=""
            fi
            echo "current_queries.value $VALUE"
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
        arangodb_rocksdb_wal_ticks)
            VALUE=$(get_metrics_value "rocksdb_wal_released_tick_flush")
            echo "wal_released_tick_flush.value $VALUE"
            VALUE=$(get_metrics_value "rocksdb_wal_released_tick_replication")
            echo "wal_released_tick_replication.value $VALUE"
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
        arangodb_rocksdb_engine_throttle)
            VALUE=$(get_metrics_value "rocksdb_engine_throttle_bps")
            echo "rocksdb_engine_throttle_bps.value $VALUE"
            ;;
        arangodb_document_read_time)
            VALUE=$(get_metrics_value 'arangodb_document_read_time_bucket{role="SINGLE",le="0.000010"}')
            echo "doc_reads_10µs.value $VALUE"
            V1=$VALUE
            VALUE=$(get_metrics_value 'arangodb_document_read_time_bucket{role="SINGLE",le="0.001000"}')
            echo "doc_reads_1ms.value $(($VALUE-$V1))"
            V1=$VALUE
            VALUE=$(get_metrics_value 'arangodb_document_read_time_bucket{role="SINGLE",le="0.100000"}')
            echo "doc_reads_100ms.value $(($VALUE-$V1))"
            V1=$VALUE
            VALUE=$(get_metrics_value 'arangodb_document_read_time_bucket{role="SINGLE",le="1.000000"}')
            echo "doc_reads_1s.value $(($VALUE-$V1))"
            ;;
        arangodb_document_insert_time)
            VALUE=$(get_metrics_value 'arangodb_document_insert_time_bucket{role="SINGLE",le="0.000010"}')
            echo "doc_insert_10µs.value $VALUE"
            V1=$VALUE
            VALUE=$(get_metrics_value 'arangodb_document_insert_time_bucket{role="SINGLE",le="0.001000"}')
            echo "doc_insert_1ms.value $(($VALUE-$V1))"
            V1=$VALUE
            VALUE=$(get_metrics_value 'arangodb_document_insert_time_bucket{role="SINGLE",le="0.100000"}')
            echo "doc_insert_100ms.value $(($VALUE-$V1))"
            V1=$VALUE
            VALUE=$(get_metrics_value 'arangodb_document_insert_time_bucket{role="SINGLE",le="1.000000"}')
            echo "doc_insert_1s.value $(($VALUE-$V1))"
            ;;
        arangodb_document_replace_time)
            VALUE=$(get_metrics_value 'arangodb_document_replace_time_bucket{role="SINGLE",le="0.000010"}')
            echo "doc_replace_10µs.value $VALUE"
            V1=$VALUE
            VALUE=$(get_metrics_value 'arangodb_document_replace_time_bucket{role="SINGLE",le="0.001000"}')
            echo "doc_replace_1ms.value $(($VALUE-$V1))"
            V1=$VALUE
            VALUE=$(get_metrics_value 'arangodb_document_replace_time_bucket{role="SINGLE",le="0.100000"}')
            echo "doc_replace_100ms.value $(($VALUE-$V1))"
            V1=$VALUE
            VALUE=$(get_metrics_value 'arangodb_document_replace_time_bucket{role="SINGLE",le="1.000000"}')
            echo "doc_replace_1s.value $(($VALUE-$V1))"
            ;;
        arangodb_collection_lock_acquisition_time)
            VALUE=$(get_metrics_value 'arangodb_collection_lock_acquisition_time_bucket{role="SINGLE",le="0.000010"}')
            echo "lock_acquisition_10µs.value $(($VALUE-$V1))"
            V1=$VALUE
            VALUE=$(get_metrics_value 'arangodb_collection_lock_acquisition_time_bucket{role="SINGLE",le="0.001000"}')
            echo "lock_acquisition_1ms.value $(($VALUE-$V1))"
            V1=$VALUE
            VALUE=$(get_metrics_value 'arangodb_collection_lock_acquisition_time_bucket{role="SINGLE",le="0.100000"}')
            echo "lock_acquisition_100ms.value $(($VALUE-$V1))"
            V1=$VALUE
            VALUE=$(get_metrics_value 'arangodb_collection_lock_acquisition_time_bucket{role="SINGLE",le="1.000000"}')
            echo "lock_acquisition_1s.value $(($VALUE-$V1))"
            ;;
        arangodb_scheduler_queue)
            VALUE=$(get_metrics_value "arangodb_scheduler_queue_length")
            echo "scheduler_queue_length.value $VALUE"
            VALUE=$(get_metrics_value "arangodb_scheduler_queue_full_failures_total")
            echo "scheduler_queue_failures.value $VALUE"
            ;;
        arangodb_connection_pool)
            VALUE=$(get_metrics_value "arangodb_connection_pool_connections_current")
            echo "pool_connections_current.value $VALUE"
            ;;
        arangodb_server_statistics)
            VALUE=$(get_metrics_value "arangodb_server_statistics_user_percent")
            echo "server_statistics_user_percent.value $VALUE"
            VALUE=$(get_metrics_value "arangodb_server_statistics_system_percent")
            echo "server_statistics_system_percent.value $VALUE"
            VALUE=$(get_metrics_value "arangodb_server_statistics_iowait_percent")
            echo "server_statistics_iowait_percent.value $VALUE"
            ;;
        arangodb_process_statistics)
            VALUE=$(get_metrics_value "arangodb_process_statistics_user_time")
            echo "process_statistics_user_time.value $VALUE"
            VALUE=$(get_metrics_value "arangodb_process_statistics_system_time")
            echo "process_statistics_system_time.value $VALUE"
            ;;
        arangodb_promises)
            VALUE=$(get_metrics_value "arangodb_async_existing_promises")
            echo "existing_promises.value $VALUE"
            ;;
        arangodb_search_threads)
            VALUE=$(get_metrics_value "arangodb_search_execution_threads_demand")
            echo "search_threads.value $VALUE"
            ;;
        arangodb_collection_lock_time)
            VALUE=$(get_metrics_value "arangodb_collection_lock_acquisition_micros_total")
            echo "collection_lock_acquisition_micros_total.value $VALUE"
            VALUE=$(get_metrics_value "arangodb_collection_lock_timeouts_exclusive_total")
            echo "collection_lock_timeouts_exclusive_total.value $VALUE"
            VALUE=$(get_metrics_value "arangodb_collection_lock_timeouts_write_total")
            echo "collection_lock_timeouts_write_total.value $VALUE"
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
    arangodb_arangodump
    arangodb_threads
    arangodb_queries
    arangodb_memory
    arangodb_connections
    arangodb_files
    arangodb_rocksdb_wal
    arangodb_rocksdb_wal_size
    arangodb_rocksdb_wal_ticks
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
