#!/usr/bin/env bash

MESOSBINDIR="$( cd "$( dirname "$0"  )" && pwd  )"


MASTER_WORK_DIR="/data/mesos/master"
MASTER_LOG_DIR="/data/mesos/master/log"
SLAVE_WORK_DIR="/data/mesos/slave"
SLAVE_LOG_DIR="/data/mesos/slave/log"

USAGE=" hostname and advertise_ip quorum zk is reuired \n
--hostname <hostname> \n
--advertise_ip <advertise_ip> \n
--quorum \n
--zk"

hostname=""
advertise_ip=""
quorum=""
zk=""
master=""
containerizers="docker,mesos"


case "$1" in
  start_master )
    while [[ -n "$2" ]]; do
      case "$2" in
        --hostname ) hostname=$3; shift 2;;
        --advertise_ip ) advertise_ip=$3; shift 2;;
        --quorum ) quorum=$3; shift 2;;
        --zk ) zk=$3; shift 2;;
        * ) break;;
      esac
    done
    if [ "$advertise_ip" = "" -o "$hostname" = "" -o "$quorum" = "" -o "$zk" = "" ]; then
      echo "error options"
      exit -1
    fi
    echo -n "Staring mesos-master ..."
    nohup "${MESOSBINDIR}/mesos-master" "--hostname=$hostname" "--advertise_ip=$advertise_ip" \
    "--quorum=$quorum" "--work_dir=$MASTER_WORK_DIR" "--zk=$zk" "--log_dir=$MASTER_LOG_DIR" &
    echo "started"
    ;;
  stop_master )
    pid=`ps -ef|grep mesos-master|grep -v "grep"|awk '{print $2}'`
    if [ "$pid" = "" ]; then
      echo "No mesos master server started"
      exit 0
    fi
    kill -9 $pid
    echo "Mesos master server stoped"
    ;;
  restart_master )
    shift
    "$0" stop_master ${@}
    sleep 5
    "$0" start_master ${@}
    ;;
  start_slave )
    while [[ -n "$2" ]]; do
      case "$2" in
        --hostname ) hostname=$3; shift 2;;
        --advertise_ip ) advertise_ip=$3; shift 2;;
        --master ) master=$3; shift 2;;
        --containerizers ) containerizers=$3; shift 2;;
        * ) break;;
      esac
    done
    if [ "$advertise_ip" = "" -o "$hostname" = "" -o "$master" = "" ]; then
      echo -n "error options"
      exit -1
    fi
    echo "Starting mesos slave server ..."
    nohup "${MESOSBINDIR}/mesos-agent" "--hostname=$hostname" "--advertise_ip=$advertise_ip" \
    "--work_dir=$SLAVE_WORK_DIR" "--master=$master" "--log_dir=$SLAVE_WORK_DIR" "--containerizers=$containerizers" &
    echo "started"
    ;;
  stop_slave )
    pid=`ps -ef|grep mesos-agent|grep -v "grep"|awk '{print $2}'`
    if [ "$pid" = "" ]; then
      echo "No mesos slave server started"
      exit 0
    fi
    kill -9 $pid
    echo "Mesos slave server stoped"
    ;;
  restart_slave )
    shift
    "$0" stop_slave ${@}
    sleep 5
    "$0" start_slave ${@}
    ;;
  * )
    echo -e $USAGE
    ;;
esac
