#!/bin/bash
bin="$(cd "$(dirname "$0")"; pwd)"

# the path to the tpcds-kit directory
export TPCDS_ROOT=$bin/tpcds-kit

# the table list file for tpcds
export tableNameList=$bin/tableList

# HDFS root directory for storing files
export FLATFILE_HDFS_ROOT=/apps/b_zeus/tpcds_celeborn
#export FLATFILE_HDFS_ROOT=/user/hdfs/tpcds_data_test
#export FLATFILE_HDFS_ROOT=/user/hive/tpcds_data_1G

# local directory root for storing files
export LOCAL_DATA_DIR=$bin/Data

# original data size (scale factor in GB)
# SF 3000 yields ~1TB for the store_sales table
export TPCDS_SCALE_FACTOR=3000

# determine the number of dsdgen processes for data generation
# usually set to one per physical CPU core
# example - 20 nodes @ 12 threads each
export DSDGEN_NODES=3
export DSDGEN_THREADS_PER_NODE=30
export DSDGEN_TOTAL_THREADS=$((DSDGEN_NODES * DSDGEN_THREADS_PER_NODE))

# database name
export TPCDS_DBNAME=tpcds_celeborn
# export TPCDS_DBNAME=tpcds

export SPARK_HOME=/apache/releases/spark-3.5.0.0.2.0-bin-ebay
#export SPARK_HOME=/apache/spark

export HADOOP_HOME=/apache/hadoop

export BEELINE=/apache/kyuubi/bin/beeline
export JDBC_URL="jdbc:hive2://kyuubi.hadoop.qa.ebay.com:10010/$TPCDS_DBNAME;ssl=true;principal=kyuubi/kyuubi.hadoop.qa.ebay.com@TESS.DEV.HADOOP.EBAY.COM#kyuubi.engine.share.level.subdomain=tpcds_celeborn;spark.binary.majorVersion=3.5.0;spark.celeborn.enabled=true;spark.shuffle.manager=org.apache.spark.shuffle.celeborn.SparkShuffleManager;spark.shuffle.sort.io.plugin.class=org.apache.spark.shuffle.celeborn.CelebornShuffleDataIO;spark.driver.memory=8g;spark.executor.memory=8g;spark.executor.cores=2;spark.sql.shuffle.partitions=1000;spark.hadoop.hive.exec.dynamic.partition=true;spark.hadoop.hive.exec.dynamic.partition.mode=nonstrict;spark.hadoop.hive.exec.max.dynamic.partitions.pernode=2000;spark.hadoop.hive.exec.max.dynamic.partitions=2000;spark.speculation=true"
# export JDBC_URL="jdbc:hive2://localhost:10009/$TPCDS_DBNAME;#spark.sql.shuffle.partitions=2;spark.executor.memory=5g;kyuubi.engine.share.level.subdomain=spark-tpcds"

export QUERY_SQL_DIR=$bin/query_sql_$TPCDS_SCALE_FACTOR
export QUERY_RESULT_DIR=$bin/query_result_$TPCDS_SCALE_FACTOR

export QUERY_EXEC_TIMES=${QUERY_EXEC_TIMES:-3}
