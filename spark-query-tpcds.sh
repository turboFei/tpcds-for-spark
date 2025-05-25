#!/bin/bash
bin=`dirname $0`
bin=`cd $bin;pwd`

set -e
source tpcds-env.sh


if [ ! -d $QUERY_SQL_DIR ];then
        echo "query sql is not exist,exit.."
	exit;
fi

if [ -d $QUERY_RESULT_DIR ];then
        rm -rf $QUERY_RESULT_DIR
fi

mkdir $QUERY_RESULT_DIR

# Unsupported SQL IDs
#ids=(28 61 77 88 90)
ids=()

# SQL IDs to skip
ids2=()

echo "-----------Starting Query-----------"
echo "-----------Database: $TPCDS_DBNAME------------"

# Execute SQL queries
for (( i=1; i<100; ++i ))
do
    yes=1
    for j in ${ids[@]}
    do
        if [ $i -eq $j ]; then
            yes=0
            break;
        fi
    done
    if [ $yes -eq 0 ]; then
        continue
    fi

    for k in ${ids2[@]}
    do
        if [ $i -eq $k ]; then
            yes=0
            break;
        fi
    done
    if [ $yes -eq 0 ]; then
        continue
    fi

    file="$QUERY_SQL_DIR/query$i.sql"
    if [ ! -f $file ]; then
        echo "$file does not exist!"
        exit 1
    fi

    echo "$file in progress, each query is executed three times and average time is taken"
    result="$QUERY_RESULT_DIR/query.result"
    echo -n "query$i.sql," >> $result
    for(( times=1;times<=3;times++))
    do
      echo "${file}_$times in progress"
      sysout="$QUERY_RESULT_DIR/query${i}_$times.out"
      $SPARK_HOME/bin/spark-sql $@ --database $TPCDS_DBNAME --name ${file}_$times -f "$file" --silent > $sysout 2>&1
      time=`cat $sysout | grep "Time taken:" | grep "Driver" | awk -F 'Time taken:' '{print $2}' | awk -F ' ' '{print $1}'`

      if [ "$time" = "" ]; then
          echo -n "0," >> $result
      else
          echo -n "$time," >> $result
      fi
    done
    echo "" >> $result
done

exit 0