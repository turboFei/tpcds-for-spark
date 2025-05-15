# Execution Steps:

## 1. Set Environment Variables

Edit the environment configuration file:
```shell
vi tpcds-env.sh
```
- Data size
- Environment variables
- Set data generation node by editing `nodenum.sh`

## 2. Generate Test Data

```shell
sudo apt-get install make flex bison byacc git g++-9 gcc-9
cd tpcds-kit/tools
make clean
make CC=gcc-9 OS=LINUX
cd ../..
./gen-data.sh
```

## 3. Create HDFS Data Directories

```shell
./hdfs-mkdirs.sh
```

## 4. Upload Data to HDFS

```shell
./upload-data.sh
```

## 5. Create External Tables

```shell
create-external-tables.sh
```

## 6. Create Partitioned Tables and Format/Compress Fact Tables with Spark-SQL or Beeline

```shell
create-parquet-partition-tables.sh
# create-parquet-partition-tables-beeline.sh
```

## 7. Generate Query SQL

```shell
./gen-sql.sh
```

## 8. Execute Tests Using Spark SQL

```shell
./spark-query-tpcds.sh
```

## 9. Execute Tests Using Beeline

```shell
./spark-query-tpcds-beeline.sh
```

*Note: The corresponding Thrift server needs to be started beforehand.*

## 10. Explanation

- The `query_templates` directory in `tpcds-kit` contains the latest modified SQL templates.
- The `query_templates_modify` directory contains the modified SQL statements adapted for Spark.

Original project: https://github.com/cloudera/impala-tpcds-kit  
This project is intended to facilitate testing on Spark. If there is any copyright infringement, it will be removed immediately.
