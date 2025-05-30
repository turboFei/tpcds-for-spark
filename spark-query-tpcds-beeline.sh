#!/bin/bash
set -e
source tpcds-env.sh

if [ ! -d ${QUERY_SQL_DIR} ];then
  echo "query sql is not exist,exit.."
  exit 1
fi

#QUERY_RESULT_BEELINE_DIR=${QUERY_RESULT_DIR}_ne_beeline
QUERY_RESULT_BEELINE_DIR=${QUERY_RESULT_DIR}_apache_beeline


if [ -d $QUERY_RESULT_BEELINE_DIR ];then
  rm -rf $QUERY_RESULT_BEELINE_DIR
fi

mkdir -p $QUERY_RESULT_BEELINE_DIR

#unsupported sql ids
#ids=(5 8 9 10 13 14 18 22 23 24 27 35 36 38 41 44 45 66 67 70 77 80 84 86 87)
ids=()

#skip ids
#ids2=(1 2 3 4 5 6 7 8 9 10 11 12 13 14)
ids2=()

echo "-----------Starting Query-----------"
echo "-----------Database: $TPCDS_DBNAME------------"

#exec sql
for (( i=1;i<100;++i ))
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
        echo "$file is not exist!"
        exit 1
    fi

    echo "$file in progress, each query is executed ${QUERY_EXEC_TIMES} times and average time is taken"
    result="${QUERY_RESULT_BEELINE_DIR}/query.result"
    echo -n "query$i.sql," >> $result
    for(( times=1;times<=${QUERY_EXEC_TIMES};times++))
    do
      echo "${file}_$times in progress"
      sysout="${QUERY_RESULT_BEELINE_DIR}/query${i}_$times.out"
      ${BEELINE} -u $JDBC_URL -f "$file" >$sysout 2>&1
      time=`cat $sysout | grep "seconds)" | cut -d "(" -f 2 | cut -d ")" -f 1 | cut -d " " -f 1`
      if [ "$time" = "" ];then
         echo -n "0," >> $result
      else
         echo -n "${time}," >> $result
      fi
    done 
    echo "" >> $result

done
