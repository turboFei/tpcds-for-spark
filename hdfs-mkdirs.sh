#!/bin/bash
set -e
bin=`dirname $0`
bin=`cd $bin;pwd`

source $bin/tpcds-env.sh

#mkdir the root dir of HDFS
$HADOOP_HOME/bin/hadoop fs -test -e ${FLATFILE_HDFS_ROOT}
if [ $? -eq 0 ] ;then
    echo 'exist'
else
    $HADOOP_HOME/bin/hadoop fs -mkdir ${FLATFILE_HDFS_ROOT}
fi

#mkdir for each table
cat $tableNameList | while read table
do
$HADOOP_HOME/bin/hadoop fs -test -e ${FLATFILE_HDFS_ROOT}/$table

if [ $? -eq 0 ] ;then
    echo 'exist'
else
  echo "making HDFS directory ${FLATFILE_HDFS_ROOT}/${table}"
  $HADOOP_HOME/bin/hadoop fs -mkdir ${FLATFILE_HDFS_ROOT}/$table
fi
done


echo "HDFS directories:"
$HADOOP_HOME/bin/hadoop fs -ls ${FLATFILE_HDFS_ROOT}
