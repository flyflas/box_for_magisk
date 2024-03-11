#!/system/bin/sh

#################################################################################
# Script Name: ipv6_monitor.sh
# Created Date: 2024/02/24
# Author: flyflas
# Version: 1.0
# Description: ip6tables rule update script
#              When IPv6 address changes, update the ip6tables rules. 
#                   To avoid the occurrence of loops
# Attention: It will only be executed when box_for_magisk is running on tproxy and clash
#################################################################################

source /data/adb/box/settings.ini

saved_ipv6=()

log Info "ipv6_monitor.sh: ipv6 monitor start..."

while true; do
    current_ipv6=($(ip -6 a | busybox awk '/inet6/ {print $2}' | busybox grep -vE "^fe80|^::1|^fd00"))
    if [ "${saved_ipv6[*]}" != "${current_ipv6[*]}" ]; then
        log Info "ipv6_monitor.sh: IPv6 address changed!\n ${saved_ipv6[*]}\n TO \n${current_ipv6[*]}"

        for address in "${saved_ipv6[@]}"; do
            ip6tables -t mangle -D BOX_EXTERNAL -d "${address}" -j RETURN
            ip6tables -t mangle -D BOX_LOCAL -d "${address}" -j RETURN
        done

        for address in "${current_ipv6[@]}"; do
            ip6tables -w 64 -t mangle -I BOX_EXTERNAL -d "${address}" -j RETURN
            ip6tables -w 64 -t mangle -I BOX_LOCAL -d "${address}" -j RETURN
        done
        
        saved_ipv6=("${current_ipv6[@]}")
    fi
    
    sleep 60
done
