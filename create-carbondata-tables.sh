#!/bin/bash
set -e
bin="$(cd "$(dirname "$0")";pwd)"
source $bin/tpcds-env.sh

$SPARK_HOME/bin/spark-sql $@ --database $TPCDS_DBNAME -f $bin/create-table-sql/create-load-carbondata-dimension.sql
$SPARK_HOME/bin/spark-sql $@ --database $TPCDS_DBNAME -f $bin/create-table-sql/create-load-carbondata-fact.sql
