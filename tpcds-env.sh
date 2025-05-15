#!/bin/bash
bin="$(cd "$(dirname "$0")"; pwd)"

# the path to the tpcds-kit directory
export TPCDS_ROOT=$bin/tpcds-kit

# the table list file for tpcds
export tableNameList=$bin/tableList

# HDFS root directory for storing files
export FLATFILE_HDFS_ROOT=/user/hive/tpcds_data
#export FLATFILE_HDFS_ROOT=/user/hdfs/tpcds_data_test
#export FLATFILE_HDFS_ROOT=/user/hive/tpcds_data_1G

# local directory root for storing files
export LOCAL_DATA_DIR=$bin/Data

# original data size (scale factor in GB)
# SF 3000 yields ~1TB for the store_sales table
export TPCDS_SCALE_FACTOR=1000

# determine the number of dsdgen processes for data generation
# usually set to one per physical CPU core
# example - 20 nodes @ 12 threads each
export DSDGEN_NODES=3
export DSDGEN_THREADS_PER_NODE=30
export DSDGEN_TOTAL_THREADS=$((DSDGEN_NODES * DSDGEN_THREADS_PER_NODE))

# database name
export TPCDS_DBNAME=tpcds

export SPARK_HOME=/apache/spark
export HADOOP_HOME=/apache/hadoop

export BEELINE=$SPARK_HOME/bin/beeline
export JDBC_URL="jdbc:hive2://localhost:10009/$TPCDS_DBNAME;#spark.sql.shuffle.partitions=2;spark.executor.memory=5g;kyuubi.engine.share.level.subdomain=spark-tpcds"

export QUERY_SQL_DIR=$bin/query_sql_$TPCDS_SCALE_FACTOR
export QUERY_RESULT_DIR=$bin/query_result_$TPCDS_SCALE_FACTOR
