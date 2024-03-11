#!/system/bin/sh

#################################################################################
# Script Name: ipv6_daemon.sh
# Created Date: 2024/02/24
# Author: flyflas
# Version: 1.0
# Description: Guardian script for ipv6_monitor.sh.
#              This script can restart ipv6_monitor.sh when ipv6_monitor.sh exits  
#                 for some reason
#              Executed every 5 minutes. You can change the time interval between 
#                 running the script in crontab (box.iptables box_run_crontab)
#################################################################################

source /data/adb/box/settings.ini

if ! busybox pgrep -f ipv6_monitor.sh > /dev/null; then
   log Info "ipv6_daemon.sh: Start ipv6_monitor.sh..."
   busybox nohup ${box_dir}/ipv6/ipv6_monitor.sh &
fi
