#!/usr/bin/env bash

MARATHONBINDIR="$( cd "$( dirname "$0"  )" && pwd  )"

USAGE=" master and zk is reuired \n
--master \n
--zk"

master=""
zk=""
libmesos_path=""
hostname=""
log_dir="/data/marathon/log"


case "$1" in
  start )
    while [[ -n "$2" ]]; do
      case "$2" in
        --master ) master=$3; shift 2;;
        --zk ) zk=$3; shift 2;;
        --libmesos_path ) libmesos_path=$3; shift 2;;
        --hostname ) hostname=$3; shift 2;;
        --log_dir ) log_dir=$3; shift 2;;
        * ) break;;
      esac
    done
    if [ "$master" = "" -o "$zk" = "" -o "$hostname" = ""]; then
      echo "error options"
      exit -1
    fi
    echo -n "Staring mesos-master ..."
    log_file="$log_dir/marathon`date +%s`.out"
    if [ ["$libmesos_path" = ""] ]; then
      nohup "${MARATHONBINDIR}/marathon" "--master" "$master" "--zk" "$zk" "--hostname" "$hostname" \
      > "$log_file" 2>&1 < /dev/null &
    else
      export MESOS_NATIVE_JAVA_LIBRARY=${libmesos_path}
      nohup "${MARATHONBINDIR}/marathon" "--master" "$master" "--zk" "$zk" "--hostname" "$hostname" \
      > "$log_file" 2>&1 < /dev/null &
    fi
    echo "started"
    ;;
  stop )
    pid=`ps -ef|grep marathon|grep -v "grep"|awk '{print $2}'`
    if [ "$pid" = "" ]; then
      echo "No marathon server started"
      exit 0
    fi
    kill -9 $pid
    echo "Mesos master server stoped"
    ;;
  restart )
    shift
    "$0" stop ${@}
    sleep 5
    "$0" start ${@}
    ;;
esac
