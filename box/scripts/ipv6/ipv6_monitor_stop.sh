#!/system/bin/sh

#################################################################################
# Script Name: ipv6_monitor_stop.sh
# Created Date: 2024/02/24
# Author: flyflas
# Version: 1.0
# Description: Script to terminate ipv6_monitor.sh
#              When box_for_magisk needs to restart or exit, this script is used to end the ipv6_monitor.sh process.
#################################################################################


source /data/adb/box/settings.ini

PIDS=$(busybox pgrep -f ipv6_monitor.sh)

log Info "ipv6_monitor_stop.sh: Kill ipv6_monitor.sh..."

if [ -z "$PIDS" ]; then
  log Error "ipv6_monitor_stop.sh: No ipv6_monitor.sh process found!!!"
else
  for PID in $PIDS; do
    busybox kill $PID
    if [ $? -eq 0 ]; then
      log Info "ipv6_monitor_stop.sh: Successfully stopped ipv6_monitor.sh:  $PID"
    else
      log Info "ipv6_monitor_stop.sh: Failed to stop ipv6_monitor.sh $PID"
    fi
  done
fi
