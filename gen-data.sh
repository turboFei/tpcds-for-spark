#!/bin/bash
bin=`dirname $0`
bin=`cd $bin; pwd`

source $bin/tpcds-env.sh

# Determine the node number
source $bin/nodenum.sh

# Generate local storage path for the dataset
LOCAL_DATA_PATH=${LOCAL_DATA_DIR}${NODENUM}
echo $LOCAL_DATA_PATH

if [ ! -d "$LOCAL_DATA_PATH" ]; then
   mkdir $LOCAL_DATA_PATH
fi

count=$DSDGEN_THREADS_PER_NODE
start=(NODENUM-1)*$count+1

# Concurrently generate data for each table slice
end=$count+$start
for (( c=$start; c<$end; c++ ))
do
  echo "Generating part $c of ${DSDGEN_TOTAL_THREADS}"
  ${TPCDS_ROOT}/tools/dsdgen \
    -SCALE ${TPCDS_SCALE_FACTOR} \
    -CHILD $c \
    -PARALLEL ${DSDGEN_TOTAL_THREADS} \
    -DISTRIBUTIONS ${TPCDS_ROOT}/tools/tpcds.idx \
    -TERMINATE N \
    -FORCE Y \
    -DIR ${LOCAL_DATA_PATH} &
done