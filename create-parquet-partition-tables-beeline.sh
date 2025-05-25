#!/bin/bash
set -e
bin=`dirname $0`
bin=`cd $bin;pwd`

source $bin/tpcds-env.sh

${BEELINE} -u $JDBC_URL -f $bin/create-table-sql/create-load-gzip-parquet-dimension.sql
${BEELINE} -u $JDBC_URL -f $bin/create-table-sql/create-load-gzip-parquet-partition-fact.sql
